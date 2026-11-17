import os

SCRATCH_DIR = "/Users/anggasopyan/.gemini/antigravity/scratch/roblox-brainrot-bounty"
SRC_SHARED = os.path.join(SCRATCH_DIR, "src/shared")
SRC_SERVER = os.path.join(SCRATCH_DIR, "src/server")
SRC_CLIENT = os.path.join(SCRATCH_DIR, "src/client")
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
hud_controller_src = read_file(os.path.join(SRC_CLIENT, "HUDController.luau"))
egg_shop_client_src = read_file(os.path.join(SRC_CLIENT, "EggShopClient.luau"))

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

def make_part(name, size, pos, color_uint=4284572001, anchored=True, can_collide=True, shape=1):
    ref = get_ref()
    shape_tag = f'<token name="shape">{shape}</token>' if shape != 1 else ''
    return f"""<Item class="Part" referent="{ref}">
        <Properties>
            <string name="Name">{name}</string>
            <bool name="Anchored">{'true' if anchored else 'false'}</bool>
            <bool name="CanCollide">{'true' if can_collide else 'false'}</bool>
            {shape_tag}
            {make_cframe(pos[0], pos[1], pos[2])}
            <Vector3 name="size">
                <X>{size[0]}</X><Y>{size[1]}</Y><Z>{size[2]}</Z>
            </Vector3>
            <Color3uint8 name="Color3uint8">{color_uint}</Color3uint8>
        </Properties>
    </Item>"""

def make_sign(name, pos, title_text, size=(10, 4, 1), bg_color=4280295459, text_color=(1, 1, 1)):
    ref = get_ref()
    gui_ref = get_ref()
    label_ref = get_ref()
    return f"""<Item class="Part" referent="{ref}">
        <Properties>
            <string name="Name">{name}</string>
            <bool name="Anchored">true</bool>
            <bool name="CanCollide">true</bool>
            {make_cframe(pos[0], pos[1], pos[2])}
            <Vector3 name="size">
                <X>{size[0]}</X><Y>{size[1]}</Y><Z>{size[2]}</Z>
            </Vector3>
            <Color3uint8 name="Color3uint8">{bg_color}</Color3uint8>
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
                        <R>{text_color[0]}</R><G>{text_color[1]}</G><B>{text_color[2]}</B>
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
    
    floor_part = make_part("Floor", (42, 1, 42), (x, 0.5, z), color_uint=4281878343)
    sign_part = make_sign("Sign", (x, 4, z - 18), f"Base {base_num} (Kosong)", text_color=(0.2, 1, 0.4))
    
    stand1 = make_part("Stand1", (6, 2, 6), (x - 12, 1.5, z - 5), color_uint=4294951475)
    stand2 = make_part("Stand2", (6, 2, 6), (x, 1.5, z - 5), color_uint=4294951475)
    stand3 = make_part("Stand3", (6, 2, 6), (x + 12, 1.5, z - 5), color_uint=4294951475)
    
    return f"""<Item class="Model" referent="{model_ref}">
        <Properties>
            <string name="Name">Base{base_num}</string>
        </Properties>
        {floor_part}
        <Item class="SpawnLocation" referent="{spawn_ref}">
            <Properties>
                <string name="Name">SpawnPoint</string>
                <bool name="Anchored">true</bool>
                {make_cframe(x, 0.6, z + 12)}
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

# 8 Bases
z_offsets = [-90, -30, 30, 90]
bases_xml = ""
for i, z in enumerate(z_offsets):
    base_left = (i * 2) + 1   # 1, 3, 5, 7
    base_right = (i * 2) + 2  # 2, 4, 6, 8
    bases_xml += make_base(base_left, -70, z)
    bases_xml += make_base(base_right, 70, z)

# Central Market Stalls (Lapak Telur 3D di Pasar Tengah)
def make_egg_stall(stall_name, egg_title, cost_text, pos, egg_color_uint):
    model_ref = get_ref()
    table_part = make_part("MejaLapak", (12, 3, 8), (pos[0], 1.5, pos[1]), color_uint=4283838760)
    roof_part = make_part("AtapLapak", (14, 1.5, 10), (pos[0], 8, pos[1]), color_uint=4294922530)
    egg_display = make_part("TelurModel", (4, 5, 4), (pos[0], 5.5, pos[1]), color_uint=egg_color_uint)
    stall_sign = make_sign("PapanTelur", (pos[0], 10, pos[1]), f"{egg_title}\n{cost_text}", size=(12, 3, 1), text_color=(1, 0.85, 0))
    
    return f"""<Item class="Model" referent="{model_ref}">
        <Properties>
            <string name="Name">{stall_name}</string>
        </Properties>
        {table_part}
        {roof_part}
        {egg_display}
        {stall_sign}
    </Item>"""

stalls_xml = ""
stalls_xml += make_egg_stall("LapakOhio", "TELUR OHIO 🥚", "100 Koin", (-18, -40), 4294967295)
stalls_xml += make_egg_stall("LapakRizz", "TELUR RIZZ 🟣", "1,200 Koin", (18, -40), 4287840488)
stalls_xml += make_egg_stall("LapakSkibidi", "TELUR SKIBIDI 🔴", "10,000 Koin", (-18, 40), 4294917670)
stalls_xml += make_egg_stall("LapakSigma", "TELUR SIGMA 🗿", "75,000 Koin", (18, 40), 4294951475)

# Plaza Nusantara Center
plaza_floor = make_part("PlazaLantai", (65, 1, 250), (0, 0.5, 0), color_uint=4289374890)
plaza_sign = make_sign("PasarSign", (0, 12, -120), "🏛️ PASAR NUSANTARA 🥚", size=(25, 6, 2), text_color=(1, 0.9, 0.2))

# Gapura Gerbang Nusantara (Atas)
gapura_tiang1 = make_part("GapuraTiangKiri", (4, 18, 4), (-15, 9, 120), color_uint=4282598460)
gapura_tiang2 = make_part("GapuraTiangKanan", (4, 18, 4), (15, 9, 120), color_uint=4282598460)
gapura_atap = make_part("GapuraAtap", (36, 4, 6), (0, 19, 120), color_uint=4294922530)
gapura_sign = make_sign("GapuraSign", (0, 22, 120), "⛩️ GERBANG NUSANTARA", size=(24, 4, 1), text_color=(1, 1, 1))

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
		{stalls_xml}
		{gapura_tiang1}
		{gapura_tiang2}
		{gapura_atap}
		{gapura_sign}
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
	<Item class="StarterPlayer" referent="RBXStarterPlayer">
		<Properties>
			<string name="Name">StarterPlayer</string>
		</Properties>
		<Item class="StarterPlayerScripts" referent="RBXStarterPlayerScripts">
			<Properties>
				<string name="Name">StarterPlayerScripts</string>
			</Properties>
			<Item class="LocalScript" referent="RBXHUDController">
				<Properties>
					<string name="Name">HUDController</string>
					<ProtectedString name="Source"><![CDATA[{hud_controller_src}]]></ProtectedString>
				</Properties>
			</Item>
			<Item class="LocalScript" referent="RBXEggShopClient">
				<Properties>
					<string name="Name">EggShopClient</string>
					<ProtectedString name="Source"><![CDATA[{egg_shop_client_src}]]></ProtectedString>
				</Properties>
			</Item>
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

print("Generated full experience successfully:", OUTPUT_FILE)
