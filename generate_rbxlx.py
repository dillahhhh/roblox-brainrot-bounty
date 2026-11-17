import os

SCRATCH_DIR = "/Users/anggasopyan/.gemini/antigravity/scratch/roblox-brainrot-bounty"
SRC_SHARED = os.path.join(SCRATCH_DIR, "src/shared")
SRC_SERVER = os.path.join(SCRATCH_DIR, "src/server")
OUTPUT_FILE = os.path.join(SCRATCH_DIR, "PasarTelurBrainrot.rbxlx")

def read_file(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

egg_config_src = read_file(os.path.join(SRC_SHARED, "EggConfig.luau"))
economy_service_src = read_file(os.path.join(SRC_SERVER, "EconomyService.luau"))
plot_manager_src = read_file(os.path.join(SRC_SERVER, "PlotManager.luau"))
egg_service_src = read_file(os.path.join(SRC_SERVER, "EggService.luau"))
pedestal_service_src = read_file(os.path.join(SRC_SERVER, "PedestalService.luau"))
market_chest_src = read_file(os.path.join(SRC_SERVER, "MarketChest.luau"))

ref_counter = 100
def get_ref():
    global ref_counter
    ref_counter += 1
    return f"RBX_{ref_counter}"

def make_cframe(x, y, z):
    return f"""<CoordinateFrame name="CFrame">
        <X>{x}</X><Y>{y}</Y><Z>{z}</Z>
        <R00>1</R00><R01>0</R01><R02>0</R02>
        <R10>0</R10><R11>1</R11><R12>0</R12>
        <R20>0</R20><R21>0</R21><R22>1</R22>
    </CoordinateFrame>"""

def make_part(name, size, pos, color_uint=4284572001, anchored=True, can_collide=True):
    ref = get_ref()
    return f"""<Item class="Part" referent="{ref}">
        <Properties>
            <string name="Name">{name}</string>
            <bool name="Anchored">{'true' if anchored else 'false'}</bool>
            <bool name="CanCollide">{'true' if can_collide else 'false'}</bool>
            {make_cframe(pos[0], pos[1], pos[2])}
            <Vector3 name="size">
                <X>{size[0]}</X><Y>{size[1]}</Y><Z>{size[2]}</Z>
            </Vector3>
            <Color3uint8 name="Color3uint8">{color_uint}</Color3uint8>
        </Properties>
    </Item>"""

def make_sign(name, pos, title_text):
    ref = get_ref()
    gui_ref = get_ref()
    label_ref = get_ref()
    return f"""<Item class="Part" referent="{ref}">
        <Properties>
            <string name="Name">Sign</string>
            <bool name="Anchored">true</bool>
            <bool name="CanCollide">true</bool>
            {make_cframe(pos[0], pos[1], pos[2])}
            <Vector3 name="size">
                <X>10</X><Y>4</Y><Z>1</Z>
            </Vector3>
            <Color3uint8 name="Color3uint8">4280295459</Color3uint8>
        </Properties>
        <Item class="SurfaceGui" referent="{gui_ref}">
            <Properties>
                <string name="Name">SurfaceGui</string>
                <token name="Face">5</token>
                <bool name="AlwaysOnTop">false</bool>
            </Properties>
            <Item class="TextLabel" referent="{label_ref}">
                <Properties>
                    <string name="Name">TextLabel</string>
                    <string name="Text">{title_text}</string>
                    <UDim2 name="Size">
                        <XS>1</XS><XO>0</XO><YS>1</YS><YO>0</YO>
                    </UDim2>
                    <Color3 name="TextColor3">
                        <R>1</R><G>1</G><B>1</B>
                    </Color3>
                    <bool name="TextScaled">true</bool>
                    <token name="Font">17</token>
                    <float name="BackgroundTransparency">1</float>
                </Properties>
            </Item>
        </Item>
    </Item>"""

def make_base(base_num, x, z):
    model_ref = get_ref()
    spawn_ref = get_ref()
    pedestals_ref = get_ref()
    
    floor_part = make_part("Floor", (40, 1, 40), (x, 0.5, z), color_uint=4281878343)
    sign_part = make_sign(f"SignBase{base_num}", (x, 4, z - 18), f"Base {base_num} (Kosong)")
    
    stand1 = make_part("Stand1", (6, 2, 6), (x - 10, 1.5, z - 5), color_uint=4294951475)
    stand2 = make_part("Stand2", (6, 2, 6), (x, 1.5, z - 5), color_uint=4294951475)
    stand3 = make_part("Stand3", (6, 2, 6), (x + 10, 1.5, z - 5), color_uint=4294951475)
    
    return f"""<Item class="Model" referent="{model_ref}">
        <Properties>
            <string name="Name">Base{base_num}</string>
        </Properties>
        {floor_part}
        <Item class="SpawnLocation" referent="{spawn_ref}">
            <Properties>
                <string name="Name">SpawnPoint</string>
                <bool name="Anchored">true</bool>
                {make_cframe(x, 0.6, z + 10)}
                <Vector3 name="size"><X>6</X><Y>1</Y><Z>6</Z></Vector3>
                <Color3uint8 name="Color3uint8">4278241535</Color3uint8>
                <bool name="Neutral">true</bool>
            </Properties>
        </Item>
        {sign_part}
        <Item class="Folder" referent="{pedestals_ref}">
            <Properties>
                <string name="Name">Pedestals</string>
            </Properties>
            {stand1}
            {stand2}
            {stand3}
        </Item>
    </Item>"""

# Generate 8 Symmetrical Bases
# Left side (Base 1, 3, 5, 7) at X = -70
# Right side (Base 2, 4, 6, 8) at X = +70
z_offsets = [-90, -30, 30, 90]
bases_xml = ""

for i, z in enumerate(z_offsets):
    base_left = (i * 2) + 1   # 1, 3, 5, 7
    base_right = (i * 2) + 2  # 2, 4, 6, 8
    bases_xml += make_base(base_left, -70, z)
    bases_xml += make_base(base_right, 70, z)

# Plaza Tengah (Central Market)
plaza_floor = make_part("PlazaLantai", (60, 1, 240), (0, 0.5, 0), color_uint=4289374890)
plaza_sign = make_sign("PasarSign", (0, 8, -110), "🏛️ PASAR NUSANTARA 🥚")

full_xml = f"""<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
	<Item class="Workspace" referent="RBXWorkspace">
		<Properties>
			<string name="Name">Workspace</string>
			<bool name="FilteringEnabled">true</bool>
		</Properties>
		<Item class="Part" referent="RBXBaseplate">
			<Properties>
				<string name="Name">Baseplate</string>
				<bool name="Anchored">true</bool>
				{make_cframe(0, -10, 0)}
				<Vector3 name="size">
					<X>512</X><Y>20</Y><Z>512</Z>
				</Vector3>
				<Color3uint8 name="Color3uint8">4284572001</Color3uint8>
			</Properties>
		</Item>
		{plaza_floor}
		{plaza_sign}
		<Item class="Folder" referent="RBXPlotsFolder">
			<Properties>
				<string name="Name">Plots</string>
			</Properties>
			{bases_xml}
		</Item>
	</Item>
	<Item class="ReplicatedStorage" referent="RBXReplicatedStorage">
		<Properties>
			<string name="Name">ReplicatedStorage</string>
		</Properties>
		<Item class="ModuleScript" referent="RBXEggConfig">
			<Properties>
				<string name="Name">EggConfig</string>
				<ProtectedString name="Source"><![CDATA[{egg_config_src}]]></ProtectedString>
			</Properties>
		</Item>
		<Item class="Folder" referent="RBXEventsFolder">
			<Properties>
				<string name="Name">Events</string>
			</Properties>
			<Item class="RemoteFunction" referent="RBXBuyEggFunc">
				<Properties>
					<string name="Name">BuyEgg</string>
				</Properties>
			</Item>
		</Item>
	</Item>
	<Item class="ServerScriptService" referent="RBXServerScriptService">
		<Properties>
			<string name="Name">ServerScriptService</string>
		</Properties>
		<Item class="Script" referent="RBXPlotManager">
			<Properties>
				<string name="Name">PlotManager</string>
				<ProtectedString name="Source"><![CDATA[{plot_manager_src}]]></ProtectedString>
			</Properties>
		</Item>
		<Item class="Script" referent="RBXEconomyService">
			<Properties>
				<string name="Name">EconomyService</string>
				<ProtectedString name="Source"><![CDATA[{economy_service_src}]]></ProtectedString>
			</Properties>
		</Item>
		<Item class="Script" referent="RBXEggService">
			<Properties>
				<string name="Name">EggService</string>
				<ProtectedString name="Source"><![CDATA[{egg_service_src}]]></ProtectedString>
			</Properties>
		</Item>
		<Item class="Script" referent="RBXPedestalService">
			<Properties>
				<string name="Name">PedestalService</string>
				<ProtectedString name="Source"><![CDATA[{pedestal_service_src}]]></ProtectedString>
			</Properties>
		</Item>
		<Item class="Script" referent="RBXMarketChest">
			<Properties>
				<string name="Name">MarketChest</string>
				<ProtectedString name="Source"><![CDATA[{market_chest_src}]]></ProtectedString>
			</Properties>
		</Item>
	</Item>
	<Item class="Lighting" referent="RBXLighting">
		<Properties>
			<string name="Name">Lighting</string>
			<Color3 name="Ambient"><R>0.5</R><G>0.5</G><B>0.5</B></Color3>
			<float name="Brightness">2</float>
		</Properties>
	</Item>
</roblox>
"""

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    f.write(full_xml)

print("Generated successfully:", OUTPUT_FILE)
