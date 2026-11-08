do
local Fatality = (function()
--[[
    		Fatality-Dark Interface

    Author: 4lpaca
    License: MIT
    Github: https://github.com/4lpaca-pin/Fatality
--]]

-- Export Types --
type Window = {
	Name: string,
	Keybind: string | Enum.KeyCode,
	Scale: UDim2,
	Expire: string,
	Watermark: boolean | nil
}

type Loader = {
	Name: string,
	Duration: number,
	Scale: number
}

type Menu = {
	Name: string,
	Icon: string,
	AutoFill: boolean
}

type Section = {
	Name: string,
	Position: string,
	Height: number,
}

type Listbox = {
	Name: string,
	Option: boolean,
	Multi: boolean,
	Position: string,
	Flag: string | nil,
	Height: number,
	Default: ValueBase,
	Values: {ValueBase},
	Callback: (values: {ValueBase}) -> any
}

type Elements = {
	AddToggle: (self,Config: Toggle) -> {
		Option: Elements	
	},
	AddSlider: (self,Config: Slider) -> {
		Option: Elements	
	},
	AddButton: (self,Config: Button) -> {},
	AddColorPicker: (self,Config: ColorPicker) -> {
		Option: Elements	
	},
	AddDropdown: (self,Config: Dropdown) -> {
		Option: Elements	
	},
	AddKeybind: (self,Config: Keybind) -> {
		Option: Elements	
	},
}

type Preview = {
	Position: string,
	Height: number
}

type Toggle = {
	Name: string,
	Default: boolean,
	Callback: (boolean) -> any,
	Risky: boolean,
	Option: boolean,
	Flag: string | nil,
}

type Slider = {
	Name: string,
	Default: number,
	Min: number,
	Max: number,
	Round: number,
	Type: string,
	Callback: (number) -> any,
	Risky: boolean,
	Flag: string | nil,
	Option: boolean
}

type Button = {
	Name: string,
	Callback: (number) -> any,
	Risky: boolean,
}

type ColorPicker = {
	Name: string,
	Default: Color3,
	Transparency: number,
	Callback: (number) -> any,
	Flag: string | nil,
	Option: boolean
}

type Dropdown = {
	Name: string,
	Default: string | {string},
	Values: {string},
	Callback: (string | {string}) -> any,
	Option: boolean,
	Multi: boolean,
	Flag: string | nil,
	AutoUpdate: boolean
}

type Keybind = {
	Name: string,
	Default: string | Enum.KeyCode,
	Callback: (string) -> any,
	Flag: string | nil,
	Option: boolean,
}

type Notify = {
	Title: string,
	Content: string,
	Duration: number,
	Flag: string | nil,
	Icon: string
}

type Notifier = {
	Notify: (self, Config: Notify) -> nil
}

-- Exploit Environments --
cloneref = cloneref or function(i) return i; end;
clonefunction = clonefunction or function(...) return ...; end;
hookfunction = hookfunction or function(a,b) return a; end;
getgenv = getgenv or getfenv;
protect_gui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;
getgenv().LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(f) return f end;

if game:GetService('RunService'):IsStudio() then
	local BaseWorkspace = Instance.new('Folder',game:GetService("ReplicatedFirst"));

	BaseWorkspace.Name = "WORKSPACE";

	local __get_path_c = function(path)
		return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
	end

	local __get_path = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			block = block[v];
		end;

		return block;
	end;

	getgenv().readfile = function(path)
		local path : StringValue = __get_path(path);

		return path.Value;
	end;

	getgenv().isfile = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and not message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().isfolder = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().writefile = function(path,content)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('StringValue',block);

				c.Name = tostring(v);
				c.Value = content;
			else
				if item:IsA('StringValue') and tostring(item) == v then
					item.Name = tostring(v);
					item.Value = content;
				end;

				block = item;
			end;
		end;
	end;

	getgenv().listfiles = function(path)
		local fold = __get_path(path);
		local pa = {};

		for i,v in next , fold:GetChildren() do
			if v:IsA('StringValue') then
				table.insert(pa,path..'/'..tostring(v));
			end;
		end;

		return pa;
	end;

	getgenv().makefolder = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('Folder',block);

				c.Name = tostring(v);
			else
				block = item;
			end;
		end;
	end;

	getgenv().delfile = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if item and item:IsA('StringValue') then
				item:Destroy();
			else
				block = item;
			end;
		end;
	end;
end;

-- Services --
local TextService = cloneref(game:GetService('TextService'));
local TweenService = cloneref(game:GetService('TweenService'));
local RunService = cloneref(game:GetService('RunService'));
local Players = cloneref(game:GetService('Players'));
local UserInputService = cloneref(game:GetService('UserInputService'));
local Client = Players.LocalPlayer;
local Mouse = Client:GetMouse();
local CurrentCamera = workspace.CurrentCamera;
local _,CoreGui = xpcall(function()
	return (gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui");
end,function()
	return Client.PlayerGui;
end);

-- Fatality --
local Fatality = {};

Fatality.Ascii = "qwertyuiopasdfghjklzxcvbnmQWRTYUIOPASDFGHJKLZXCVBNM";
Fatality.GLOBAL_ENVIRONMENT = {};
Fatality.Windows = {};
Fatality.FontSemiBold = Font.new('rbxasset://fonts/families/GothamSSm.json',Enum.FontWeight.SemiBold,Enum.FontStyle.Normal);
Fatality.Flags = {};
Fatality.Colors = {
    Black = Color3.fromRGB(6, 6, 10),
    Main = Color3.fromRGB(255, 140, 0),
    Background = Color3.fromRGB(10, 12, 16),
    Surface = Color3.fromRGB(24, 26, 32),
    Muted = Color3.fromRGB(120, 125, 135),
    Accent = Color3.fromRGB(0, 200, 255),       -- яркий циан для акцентов
    AccentSoft = Color3.fromRGB(120, 80, 255),  -- мягкий фиолетовый
    AccentWarm = Color3.fromRGB(255, 160, 60),  -- тёплый золотой для выделений
    Glow = Color3.fromRGB(120, 255, 200),       -- мягкое неоновое свечение
    Success = Color3.fromRGB(88, 214, 141),
    Warning = Color3.fromRGB(255, 179, 71),
    Danger = Color3.fromRGB(255, 140, 0),
    TextMain = Color3.fromRGB(240, 244, 248),
    TextDim = Color3.fromRGB(170, 175, 180),
    Overlay = Color3.fromRGB(4, 6, 10)          -- тёмный слой для фоновых оверлеев
}

Fatality.DragBlacklist = {};
Fatality.Version = '67';
Fatality.Lucide = {
	["lucide-accessibility"] = "rbxassetid://10709751939",
	["lucide-activity"] = "rbxassetid://10709752035",
	["lucide-air-vent"] = "rbxassetid://10709752131",
	["lucide-airplay"] = "rbxassetid://10709752254",
	["lucide-alarm-check"] = "rbxassetid://10709752405",
	["lucide-alarm-clock"] = "rbxassetid://10709752630",
	["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
	["lucide-alarm-minus"] = "rbxassetid://10709752732",
	["lucide-alarm-plus"] = "rbxassetid://10709752825",
	["lucide-album"] = "rbxassetid://10709752906",
	["lucide-alert-circle"] = "rbxassetid://10709752996",
	["lucide-alert-octagon"] = "rbxassetid://10709753064",
	["lucide-alert-triangle"] = "rbxassetid://10709753149",
	["lucide-align-center"] = "rbxassetid://10709753570",
	["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
	["lucide-align-center-vertical"] = "rbxassetid://10709753421",
	["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
	["lucide-align-end-vertical"] = "rbxassetid://10709753808",
	["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
	["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
	["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
	["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
	["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
	["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
	["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
	["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
	["lucide-align-justify"] = "rbxassetid://10709759610",
	["lucide-align-left"] = "rbxassetid://10709759764",
	["lucide-align-right"] = "rbxassetid://10709759895",
	["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
	["lucide-align-start-vertical"] = "rbxassetid://10709760244",
	["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
	["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
	["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
	["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
	["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
	["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
	["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
	["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
	["lucide-anchor"] = "rbxassetid://10709761530",
	["lucide-angry"] = "rbxassetid://10709761629",
	["lucide-annoyed"] = "rbxassetid://10709761722",
	["lucide-aperture"] = "rbxassetid://10709761813",
	["lucide-apple"] = "rbxassetid://10709761889",
	["lucide-archive"] = "rbxassetid://10709762233",
	["lucide-archive-restore"] = "rbxassetid://10709762058",
	["lucide-armchair"] = "rbxassetid://10709762327",
	["lucide-arrow-big-down"] = "rbxassetid://10747796644",
	["lucide-arrow-big-left"] = "rbxassetid://10709762574",
	["lucide-arrow-big-right"] = "rbxassetid://10709762727",
	["lucide-arrow-big-up"] = "rbxassetid://10709762879",
	["lucide-arrow-down"] = "rbxassetid://10709767827",
	["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
	["lucide-arrow-down-left"] = "rbxassetid://10709767656",
	["lucide-arrow-down-right"] = "rbxassetid://10709767750",
	["lucide-arrow-left"] = "rbxassetid://10709768114",
	["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
	["lucide-arrow-left-right"] = "rbxassetid://10709768019",
	["lucide-arrow-right"] = "rbxassetid://10709768347",
	["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
	["lucide-arrow-up"] = "rbxassetid://10709768939",
	["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
	["lucide-arrow-up-down"] = "rbxassetid://10709768538",
	["lucide-arrow-up-left"] = "rbxassetid://10709768661",
	["lucide-arrow-up-right"] = "rbxassetid://10709768787",
	["lucide-asterisk"] = "rbxassetid://10709769095",
	["lucide-at-sign"] = "rbxassetid://10709769286",
	["lucide-award"] = "rbxassetid://10709769406",
	["lucide-axe"] = "rbxassetid://10709769508",
	["lucide-axis-3d"] = "rbxassetid://10709769598",
	["lucide-baby"] = "rbxassetid://10709769732",
	["lucide-backpack"] = "rbxassetid://10709769841",
	["lucide-baggage-claim"] = "rbxassetid://10709769935",
	["lucide-banana"] = "rbxassetid://10709770005",
	["lucide-banknote"] = "rbxassetid://10709770178",
	["lucide-bar-chart"] = "rbxassetid://10709773755",
	["lucide-bar-chart-2"] = "rbxassetid://10709770317",
	["lucide-bar-chart-3"] = "rbxassetid://10709770431",
	["lucide-bar-chart-4"] = "rbxassetid://10709770560",
	["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
	["lucide-barcode"] = "rbxassetid://10747360675",
	["lucide-baseline"] = "rbxassetid://10709773863",
	["lucide-bath"] = "rbxassetid://10709773963",
	["lucide-battery"] = "rbxassetid://10709774640",
	["lucide-battery-charging"] = "rbxassetid://10709774068",
	["lucide-battery-full"] = "rbxassetid://10709774206",
	["lucide-battery-low"] = "rbxassetid://10709774370",
	["lucide-battery-medium"] = "rbxassetid://10709774513",
	["lucide-beaker"] = "rbxassetid://10709774756",
	["lucide-bed"] = "rbxassetid://10709775036",
	["lucide-bed-double"] = "rbxassetid://10709774864",
	["lucide-bed-single"] = "rbxassetid://10709774968",
	["lucide-beer"] = "rbxassetid://10709775167",
	["lucide-bell"] = "rbxassetid://10709775704",
	["lucide-bell-minus"] = "rbxassetid://10709775241",
	["lucide-bell-off"] = "rbxassetid://10709775320",
	["lucide-bell-plus"] = "rbxassetid://10709775448",
	["lucide-bell-ring"] = "rbxassetid://10709775560",
	["lucide-bike"] = "rbxassetid://10709775894",
	["lucide-binary"] = "rbxassetid://10709776050",
	["lucide-bitcoin"] = "rbxassetid://10709776126",
	["lucide-bluetooth"] = "rbxassetid://10709776655",
	["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
	["lucide-bluetooth-off"] = "rbxassetid://10709776344",
	["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
	["lucide-bold"] = "rbxassetid://10747813908",
	["lucide-bomb"] = "rbxassetid://10709781460",
	["lucide-bone"] = "rbxassetid://10709781605",
	["lucide-book"] = "rbxassetid://10709781824",
	["lucide-book-open"] = "rbxassetid://10709781717",
	["lucide-bookmark"] = "rbxassetid://10709782154",
	["lucide-bookmark-minus"] = "rbxassetid://10709781919",
	["lucide-bookmark-plus"] = "rbxassetid://10709782044",
	["lucide-bot"] = "rbxassetid://10709782230",
	["lucide-box"] = "rbxassetid://10709782497",
	["lucide-box-select"] = "rbxassetid://10709782342",
	["lucide-boxes"] = "rbxassetid://10709782582",
	["lucide-briefcase"] = "rbxassetid://10709782662",
	["lucide-brush"] = "rbxassetid://10709782758",
	["lucide-bug"] = "rbxassetid://10709782845",
	["lucide-building"] = "rbxassetid://10709783051",
	["lucide-building-2"] = "rbxassetid://10709782939",
	["lucide-bus"] = "rbxassetid://10709783137",
	["lucide-cake"] = "rbxassetid://10709783217",
	["lucide-calculator"] = "rbxassetid://10709783311",
	["lucide-calendar"] = "rbxassetid://10709789505",
	["lucide-calendar-check"] = "rbxassetid://10709783474",
	["lucide-calendar-check-2"] = "rbxassetid://10709783392",
	["lucide-calendar-clock"] = "rbxassetid://10709783577",
	["lucide-calendar-days"] = "rbxassetid://10709783673",
	["lucide-calendar-heart"] = "rbxassetid://10709783835",
	["lucide-calendar-minus"] = "rbxassetid://10709783959",
	["lucide-calendar-off"] = "rbxassetid://10709788784",
	["lucide-calendar-plus"] = "rbxassetid://10709788937",
	["lucide-calendar-range"] = "rbxassetid://10709789053",
	["lucide-calendar-search"] = "rbxassetid://10709789200",
	["lucide-calendar-x"] = "rbxassetid://10709789407",
	["lucide-calendar-x-2"] = "rbxassetid://10709789329",
	["lucide-camera"] = "rbxassetid://10709789686",
	["lucide-camera-off"] = "rbxassetid://10747822677",
	["lucide-car"] = "rbxassetid://10709789810",
	["lucide-carrot"] = "rbxassetid://10709789960",
	["lucide-cast"] = "rbxassetid://10709790097",
	["lucide-charge"] = "rbxassetid://10709790202",
	["lucide-check"] = "rbxassetid://10709790644",
	["lucide-check-circle"] = "rbxassetid://10709790387",
	["lucide-check-circle-2"] = "rbxassetid://10709790298",
	["lucide-check-square"] = "rbxassetid://10709790537",
	["lucide-chef-hat"] = "rbxassetid://10709790757",
	["lucide-cherry"] = "rbxassetid://10709790875",
	["lucide-chevron-down"] = "rbxassetid://10709790948",
	["lucide-chevron-first"] = "rbxassetid://10709791015",
	["lucide-chevron-last"] = "rbxassetid://10709791130",
	["lucide-chevron-left"] = "rbxassetid://10709791281",
	["lucide-chevron-right"] = "rbxassetid://10709791437",
	["lucide-chevron-up"] = "rbxassetid://10709791523",
	["lucide-chevrons-down"] = "rbxassetid://10709796864",
	["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
	["lucide-chevrons-left"] = "rbxassetid://10709797151",
	["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
	["lucide-chevrons-right"] = "rbxassetid://10709797382",
	["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
	["lucide-chevrons-up"] = "rbxassetid://10709797622",
	["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
	["lucide-chrome"] = "rbxassetid://10709797725",
	["lucide-circle"] = "rbxassetid://10709798174",
	["lucide-circle-dot"] = "rbxassetid://10709797837",
	["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
	["lucide-circle-slashed"] = "rbxassetid://10709798100",
	["lucide-citrus"] = "rbxassetid://10709798276",
	["lucide-clapperboard"] = "rbxassetid://10709798350",
	["lucide-clipboard"] = "rbxassetid://10709799288",
	["lucide-clipboard-check"] = "rbxassetid://10709798443",
	["lucide-clipboard-copy"] = "rbxassetid://10709798574",
	["lucide-clipboard-edit"] = "rbxassetid://10709798682",
	["lucide-clipboard-list"] = "rbxassetid://10709798792",
	["lucide-clipboard-signature"] = "rbxassetid://10709798890",
	["lucide-clipboard-type"] = "rbxassetid://10709798999",
	["lucide-clipboard-x"] = "rbxassetid://10709799124",
	["lucide-clock"] = "rbxassetid://10709805144",
	["lucide-clock-1"] = "rbxassetid://10709799535",
	["lucide-clock-10"] = "rbxassetid://10709799718",
	["lucide-clock-11"] = "rbxassetid://10709799818",
	["lucide-clock-12"] = "rbxassetid://10709799962",
	["lucide-clock-2"] = "rbxassetid://10709803876",
	["lucide-clock-3"] = "rbxassetid://10709803989",
	["lucide-clock-4"] = "rbxassetid://10709804164",
	["lucide-clock-5"] = "rbxassetid://10709804291",
	["lucide-clock-6"] = "rbxassetid://10709804435",
	["lucide-clock-7"] = "rbxassetid://10709804599",
	["lucide-clock-8"] = "rbxassetid://10709804784",
	["lucide-clock-9"] = "rbxassetid://10709804996",
	["lucide-cloud"] = "rbxassetid://10709806740",
	["lucide-cloud-cog"] = "rbxassetid://10709805262",
	["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
	["lucide-cloud-fog"] = "rbxassetid://10709805477",
	["lucide-cloud-hail"] = "rbxassetid://10709805596",
	["lucide-cloud-lightning"] = "rbxassetid://10709805727",
	["lucide-cloud-moon"] = "rbxassetid://10709805942",
	["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
	["lucide-cloud-off"] = "rbxassetid://10709806060",
	["lucide-cloud-rain"] = "rbxassetid://10709806277",
	["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
	["lucide-cloud-snow"] = "rbxassetid://10709806374",
	["lucide-cloud-sun"] = "rbxassetid://10709806631",
	["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
	["lucide-cloudy"] = "rbxassetid://10709806859",
	["lucide-clover"] = "rbxassetid://10709806995",
	["lucide-code"] = "rbxassetid://10709810463",
	["lucide-code-2"] = "rbxassetid://10709807111",
	["lucide-codepen"] = "rbxassetid://10709810534",
	["lucide-codesandbox"] = "rbxassetid://10709810676",
	["lucide-coffee"] = "rbxassetid://10709810814",
	["lucide-cog"] = "rbxassetid://10709810948",
	["lucide-coins"] = "rbxassetid://10709811110",
	["lucide-columns"] = "rbxassetid://10709811261",
	["lucide-command"] = "rbxassetid://10709811365",
	["lucide-compass"] = "rbxassetid://10709811445",
	["lucide-component"] = "rbxassetid://10709811595",
	["lucide-concierge-bell"] = "rbxassetid://10709811706",
	["lucide-connection"] = "rbxassetid://10747361219",
	["lucide-contact"] = "rbxassetid://10709811834",
	["lucide-contrast"] = "rbxassetid://10709811939",
	["lucide-cookie"] = "rbxassetid://10709812067",
	["lucide-copy"] = "rbxassetid://10709812159",
	["lucide-copyleft"] = "rbxassetid://10709812251",
	["lucide-copyright"] = "rbxassetid://10709812311",
	["lucide-corner-down-left"] = "rbxassetid://10709812396",
	["lucide-corner-down-right"] = "rbxassetid://10709812485",
	["lucide-corner-left-down"] = "rbxassetid://10709812632",
	["lucide-corner-left-up"] = "rbxassetid://10709812784",
	["lucide-corner-right-down"] = "rbxassetid://10709812939",
	["lucide-corner-right-up"] = "rbxassetid://10709813094",
	["lucide-corner-up-left"] = "rbxassetid://10709813185",
	["lucide-corner-up-right"] = "rbxassetid://10709813281",
	["lucide-cpu"] = "rbxassetid://10709813383",
	["lucide-croissant"] = "rbxassetid://10709818125",
	["lucide-crop"] = "rbxassetid://10709818245",
	["lucide-cross"] = "rbxassetid://10709818399",
	["lucide-crosshair"] = "rbxassetid://10709818534",
	["lucide-crown"] = "rbxassetid://10709818626",
	["lucide-cup-soda"] = "rbxassetid://10709818763",
	["lucide-curly-braces"] = "rbxassetid://10709818847",
	["lucide-currency"] = "rbxassetid://10709818931",
	["lucide-database"] = "rbxassetid://10709818996",
	["lucide-delete"] = "rbxassetid://10709819059",
	["lucide-diamond"] = "rbxassetid://10709819149",
	["lucide-dice-1"] = "rbxassetid://10709819266",
	["lucide-dice-2"] = "rbxassetid://10709819361",
	["lucide-dice-3"] = "rbxassetid://10709819508",
	["lucide-dice-4"] = "rbxassetid://10709819670",
	["lucide-dice-5"] = "rbxassetid://10709819801",
	["lucide-dice-6"] = "rbxassetid://10709819896",
	["lucide-dices"] = "rbxassetid://10723343321",
	["lucide-diff"] = "rbxassetid://10723343416",
	["lucide-disc"] = "rbxassetid://10723343537",
	["lucide-divide"] = "rbxassetid://10723343805",
	["lucide-divide-circle"] = "rbxassetid://10723343636",
	["lucide-divide-square"] = "rbxassetid://10723343737",
	["lucide-dollar-sign"] = "rbxassetid://10723343958",
	["lucide-download"] = "rbxassetid://10723344270",
	["lucide-download-cloud"] = "rbxassetid://10723344088",
	["lucide-droplet"] = "rbxassetid://10723344432",
	["lucide-droplets"] = "rbxassetid://10734883356",
	["lucide-drumstick"] = "rbxassetid://10723344737",
	["lucide-edit"] = "rbxassetid://10734883598",
	["lucide-edit-2"] = "rbxassetid://10723344885",
	["lucide-edit-3"] = "rbxassetid://10723345088",
	["lucide-egg"] = "rbxassetid://10723345518",
	["lucide-egg-fried"] = "rbxassetid://10723345347",
	["lucide-electricity"] = "rbxassetid://10723345749",
	["lucide-electricity-off"] = "rbxassetid://10723345643",
	["lucide-equal"] = "rbxassetid://10723345990",
	["lucide-equal-not"] = "rbxassetid://10723345866",
	["lucide-eraser"] = "rbxassetid://10723346158",
	["lucide-euro"] = "rbxassetid://10723346372",
	["lucide-expand"] = "rbxassetid://10723346553",
	["lucide-external-link"] = "rbxassetid://10723346684",
	["lucide-eye"] = "rbxassetid://10723346959",
	["lucide-eye-off"] = "rbxassetid://10723346871",
	["lucide-factory"] = "rbxassetid://10723347051",
	["lucide-fan"] = "rbxassetid://10723354359",
	["lucide-fast-forward"] = "rbxassetid://10723354521",
	["lucide-feather"] = "rbxassetid://10723354671",
	["lucide-figma"] = "rbxassetid://10723354801",
	["lucide-file"] = "rbxassetid://10723374641",
	["lucide-file-archive"] = "rbxassetid://10723354921",
	["lucide-file-audio"] = "rbxassetid://10723355148",
	["lucide-file-audio-2"] = "rbxassetid://10723355026",
	["lucide-file-axis-3d"] = "rbxassetid://10723355272",
	["lucide-file-badge"] = "rbxassetid://10723355622",
	["lucide-file-badge-2"] = "rbxassetid://10723355451",
	["lucide-file-bar-chart"] = "rbxassetid://10723355887",
	["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
	["lucide-file-box"] = "rbxassetid://10723355989",
	["lucide-file-check"] = "rbxassetid://10723356210",
	["lucide-file-check-2"] = "rbxassetid://10723356100",
	["lucide-file-clock"] = "rbxassetid://10723356329",
	["lucide-file-code"] = "rbxassetid://10723356507",
	["lucide-file-cog"] = "rbxassetid://10723356830",
	["lucide-file-cog-2"] = "rbxassetid://10723356676",
	["lucide-file-diff"] = "rbxassetid://10723357039",
	["lucide-file-digit"] = "rbxassetid://10723357151",
	["lucide-file-down"] = "rbxassetid://10723357322",
	["lucide-file-edit"] = "rbxassetid://10723357495",
	["lucide-file-heart"] = "rbxassetid://10723357637",
	["lucide-file-image"] = "rbxassetid://10723357790",
	["lucide-file-input"] = "rbxassetid://10723357933",
	["lucide-file-json"] = "rbxassetid://10723364435",
	["lucide-file-json-2"] = "rbxassetid://10723364361",
	["lucide-file-key"] = "rbxassetid://10723364605",
	["lucide-file-key-2"] = "rbxassetid://10723364515",
	["lucide-file-line-chart"] = "rbxassetid://10723364725",
	["lucide-file-lock"] = "rbxassetid://10723364957",
	["lucide-file-lock-2"] = "rbxassetid://10723364861",
	["lucide-file-minus"] = "rbxassetid://10723365254",
	["lucide-file-minus-2"] = "rbxassetid://10723365086",
	["lucide-file-output"] = "rbxassetid://10723365457",
	["lucide-file-pie-chart"] = "rbxassetid://10723365598",
	["lucide-file-plus"] = "rbxassetid://10723365877",
	["lucide-file-plus-2"] = "rbxassetid://10723365766",
	["lucide-file-question"] = "rbxassetid://10723365987",
	["lucide-file-scan"] = "rbxassetid://10723366167",
	["lucide-file-search"] = "rbxassetid://10723366550",
	["lucide-file-search-2"] = "rbxassetid://10723366340",
	["lucide-file-signature"] = "rbxassetid://10723366741",
	["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
	["lucide-file-symlink"] = "rbxassetid://10723367098",
	["lucide-file-terminal"] = "rbxassetid://10723367244",
	["lucide-file-text"] = "rbxassetid://10723367380",
	["lucide-file-type"] = "rbxassetid://10723367606",
	["lucide-file-type-2"] = "rbxassetid://10723367509",
	["lucide-file-up"] = "rbxassetid://10723367734",
	["lucide-file-video"] = "rbxassetid://10723373884",
	["lucide-file-video-2"] = "rbxassetid://10723367834",
	["lucide-file-volume"] = "rbxassetid://10723374172",
	["lucide-file-volume-2"] = "rbxassetid://10723374030",
	["lucide-file-warning"] = "rbxassetid://10723374276",
	["lucide-file-x"] = "rbxassetid://10723374544",
	["lucide-file-x-2"] = "rbxassetid://10723374378",
	["lucide-files"] = "rbxassetid://10723374759",
	["lucide-film"] = "rbxassetid://10723374981",
	["lucide-filter"] = "rbxassetid://10723375128",
	["lucide-fingerprint"] = "rbxassetid://10723375250",
	["lucide-flag"] = "rbxassetid://10723375890",
	["lucide-flag-off"] = "rbxassetid://10723375443",
	["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
	["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
	["lucide-flame"] = "rbxassetid://10723376114",
	["lucide-flashlight"] = "rbxassetid://10723376471",
	["lucide-flashlight-off"] = "rbxassetid://10723376365",
	["lucide-flask-conical"] = "rbxassetid://10734883986",
	["lucide-flask-round"] = "rbxassetid://10723376614",
	["lucide-flip-horizontal"] = "rbxassetid://10723376884",
	["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
	["lucide-flip-vertical"] = "rbxassetid://10723377138",
	["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
	["lucide-flower"] = "rbxassetid://10747830374",
	["lucide-flower-2"] = "rbxassetid://10723377305",
	["lucide-focus"] = "rbxassetid://10723377537",
	["lucide-folder"] = "rbxassetid://10723387563",
	["lucide-folder-archive"] = "rbxassetid://10723384478",
	["lucide-folder-check"] = "rbxassetid://10723384605",
	["lucide-folder-clock"] = "rbxassetid://10723384731",
	["lucide-folder-closed"] = "rbxassetid://10723384893",
	["lucide-folder-cog"] = "rbxassetid://10723385213",
	["lucide-folder-cog-2"] = "rbxassetid://10723385036",
	["lucide-folder-down"] = "rbxassetid://10723385338",
	["lucide-folder-edit"] = "rbxassetid://10723385445",
	["lucide-folder-heart"] = "rbxassetid://10723385545",
	["lucide-folder-input"] = "rbxassetid://10723385721",
	["lucide-folder-key"] = "rbxassetid://10723385848",
	["lucide-folder-lock"] = "rbxassetid://10723386005",
	["lucide-folder-minus"] = "rbxassetid://10723386127",
	["lucide-folder-open"] = "rbxassetid://10723386277",
	["lucide-folder-output"] = "rbxassetid://10723386386",
	["lucide-folder-plus"] = "rbxassetid://10723386531",
	["lucide-folder-search"] = "rbxassetid://10723386787",
	["lucide-folder-search-2"] = "rbxassetid://10723386674",
	["lucide-folder-symlink"] = "rbxassetid://10723386930",
	["lucide-folder-tree"] = "rbxassetid://10723387085",
	["lucide-folder-up"] = "rbxassetid://10723387265",
	["lucide-folder-x"] = "rbxassetid://10723387448",
	["lucide-folders"] = "rbxassetid://10723387721",
	["lucide-form-input"] = "rbxassetid://10723387841",
	["lucide-forward"] = "rbxassetid://10723388016",
	["lucide-frame"] = "rbxassetid://10723394389",
	["lucide-framer"] = "rbxassetid://10723394565",
	["lucide-frown"] = "rbxassetid://10723394681",
	["lucide-fuel"] = "rbxassetid://10723394846",
	["lucide-function-square"] = "rbxassetid://10723395041",
	["lucide-gamepad"] = "rbxassetid://10723395457",
	["lucide-gamepad-2"] = "rbxassetid://10723395215",
	["lucide-gauge"] = "rbxassetid://10723395708",
	["lucide-gavel"] = "rbxassetid://10723395896",
	["lucide-gem"] = "rbxassetid://10723396000",
	["lucide-ghost"] = "rbxassetid://10723396107",
	["lucide-gift"] = "rbxassetid://10723396402",
	["lucide-gift-card"] = "rbxassetid://10723396225",
	["lucide-git-branch"] = "rbxassetid://10723396676",
	["lucide-git-branch-plus"] = "rbxassetid://10723396542",
	["lucide-git-commit"] = "rbxassetid://10723396812",
	["lucide-git-compare"] = "rbxassetid://10723396954",
	["lucide-git-fork"] = "rbxassetid://10723397049",
	["lucide-git-merge"] = "rbxassetid://10723397165",
	["lucide-git-pull-request"] = "rbxassetid://10723397431",
	["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
	["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
	["lucide-glass"] = "rbxassetid://10723397788",
	["lucide-glass-2"] = "rbxassetid://10723397529",
	["lucide-glass-water"] = "rbxassetid://10723397678",
	["lucide-glasses"] = "rbxassetid://10723397895",
	["lucide-globe"] = "rbxassetid://10723404337",
	["lucide-globe-2"] = "rbxassetid://10723398002",
	["lucide-grab"] = "rbxassetid://10723404472",
	["lucide-graduation-cap"] = "rbxassetid://10723404691",
	["lucide-grape"] = "rbxassetid://10723404822",
	["lucide-grid"] = "rbxassetid://10723404936",
	["lucide-grip-horizontal"] = "rbxassetid://10723405089",
	["lucide-grip-vertical"] = "rbxassetid://10723405236",
	["lucide-hammer"] = "rbxassetid://10723405360",
	["lucide-hand"] = "rbxassetid://10723405649",
	["lucide-hand-metal"] = "rbxassetid://10723405508",
	["lucide-hard-drive"] = "rbxassetid://10723405749",
	["lucide-hard-hat"] = "rbxassetid://10723405859",
	["lucide-hash"] = "rbxassetid://10723405975",
	["lucide-haze"] = "rbxassetid://10723406078",
	["lucide-headphones"] = "rbxassetid://10723406165",
	["lucide-heart"] = "rbxassetid://10723406885",
	["lucide-heart-crack"] = "rbxassetid://10723406299",
	["lucide-heart-handshake"] = "rbxassetid://10723406480",
	["lucide-heart-off"] = "rbxassetid://10723406662",
	["lucide-heart-pulse"] = "rbxassetid://10723406795",
	["lucide-help-circle"] = "rbxassetid://10723406988",
	["lucide-hexagon"] = "rbxassetid://10723407092",
	["lucide-highlighter"] = "rbxassetid://10723407192",
	["lucide-history"] = "rbxassetid://10723407335",
	["lucide-home"] = "rbxassetid://10723407389",
	["lucide-hourglass"] = "rbxassetid://10723407498",
	["lucide-ice-cream"] = "rbxassetid://10723414308",
	["lucide-image"] = "rbxassetid://10723415040",
	["lucide-image-minus"] = "rbxassetid://10723414487",
	["lucide-image-off"] = "rbxassetid://10723414677",
	["lucide-image-plus"] = "rbxassetid://10723414827",
	["lucide-import"] = "rbxassetid://10723415205",
	["lucide-inbox"] = "rbxassetid://10723415335",
	["lucide-indent"] = "rbxassetid://10723415494",
	["lucide-indian-rupee"] = "rbxassetid://10723415642",
	["lucide-infinity"] = "rbxassetid://10723415766",
	["lucide-info"] = "rbxassetid://10723415903",
	["lucide-inspect"] = "rbxassetid://10723416057",
	["lucide-italic"] = "rbxassetid://10723416195",
	["lucide-japanese-yen"] = "rbxassetid://10723416363",
	["lucide-joystick"] = "rbxassetid://10723416527",
	["lucide-key"] = "rbxassetid://10723416652",
	["lucide-keyboard"] = "rbxassetid://10723416765",
	["lucide-lamp"] = "rbxassetid://10723417513",
	["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
	["lucide-lamp-desk"] = "rbxassetid://10723417016",
	["lucide-lamp-floor"] = "rbxassetid://10723417131",
	["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
	["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
	["lucide-landmark"] = "rbxassetid://10723417608",
	["lucide-languages"] = "rbxassetid://10723417703",
	["lucide-laptop"] = "rbxassetid://10723423881",
	["lucide-laptop-2"] = "rbxassetid://10723417797",
	["lucide-lasso"] = "rbxassetid://10723424235",
	["lucide-lasso-select"] = "rbxassetid://10723424058",
	["lucide-laugh"] = "rbxassetid://10723424372",
	["lucide-layers"] = "rbxassetid://10723424505",
	["lucide-layout"] = "rbxassetid://10723425376",
	["lucide-layout-dashboard"] = "rbxassetid://10723424646",
	["lucide-layout-grid"] = "rbxassetid://10723424838",
	["lucide-layout-list"] = "rbxassetid://10723424963",
	["lucide-layout-template"] = "rbxassetid://10723425187",
	["lucide-leaf"] = "rbxassetid://10723425539",
	["lucide-library"] = "rbxassetid://10723425615",
	["lucide-life-buoy"] = "rbxassetid://10723425685",
	["lucide-lightbulb"] = "rbxassetid://10723425852",
	["lucide-lightbulb-off"] = "rbxassetid://10723425762",
	["lucide-line-chart"] = "rbxassetid://10723426393",
	["lucide-link"] = "rbxassetid://10723426722",
	["lucide-link-2"] = "rbxassetid://10723426595",
	["lucide-link-2-off"] = "rbxassetid://10723426513",
	["lucide-list"] = "rbxassetid://10723433811",
	["lucide-list-checks"] = "rbxassetid://10734884548",
	["lucide-list-end"] = "rbxassetid://10723426886",
	["lucide-list-minus"] = "rbxassetid://10723426986",
	["lucide-list-music"] = "rbxassetid://10723427081",
	["lucide-list-ordered"] = "rbxassetid://10723427199",
	["lucide-list-plus"] = "rbxassetid://10723427334",
	["lucide-list-start"] = "rbxassetid://10723427494",
	["lucide-list-video"] = "rbxassetid://10723427619",
	["lucide-list-x"] = "rbxassetid://10723433655",
	["lucide-loader"] = "rbxassetid://10723434070",
	["lucide-loader-2"] = "rbxassetid://10723433935",
	["lucide-locate"] = "rbxassetid://10723434557",
	["lucide-locate-fixed"] = "rbxassetid://10723434236",
	["lucide-locate-off"] = "rbxassetid://10723434379",
	["lucide-lock"] = "rbxassetid://10723434711",
	["lucide-log-in"] = "rbxassetid://10723434830",
	["lucide-log-out"] = "rbxassetid://10723434906",
	["lucide-luggage"] = "rbxassetid://10723434993",
	["lucide-magnet"] = "rbxassetid://10723435069",
	["lucide-mail"] = "rbxassetid://10734885430",
	["lucide-mail-check"] = "rbxassetid://10723435182",
	["lucide-mail-minus"] = "rbxassetid://10723435261",
	["lucide-mail-open"] = "rbxassetid://10723435342",
	["lucide-mail-plus"] = "rbxassetid://10723435443",
	["lucide-mail-question"] = "rbxassetid://10723435515",
	["lucide-mail-search"] = "rbxassetid://10734884739",
	["lucide-mail-warning"] = "rbxassetid://10734885015",
	["lucide-mail-x"] = "rbxassetid://10734885247",
	["lucide-mails"] = "rbxassetid://10734885614",
	["lucide-map"] = "rbxassetid://10734886202",
	["lucide-map-pin"] = "rbxassetid://10734886004",
	["lucide-map-pin-off"] = "rbxassetid://10734885803",
	["lucide-maximize"] = "rbxassetid://10734886735",
	["lucide-maximize-2"] = "rbxassetid://10734886496",
	["lucide-medal"] = "rbxassetid://10734887072",
	["lucide-megaphone"] = "rbxassetid://10734887454",
	["lucide-megaphone-off"] = "rbxassetid://10734887311",
	["lucide-meh"] = "rbxassetid://10734887603",
	["lucide-menu"] = "rbxassetid://10734887784",
	["lucide-message-circle"] = "rbxassetid://10734888000",
	["lucide-message-square"] = "rbxassetid://10734888228",
	["lucide-mic"] = "rbxassetid://10734888864",
	["lucide-mic-2"] = "rbxassetid://10734888430",
	["lucide-mic-off"] = "rbxassetid://10734888646",
	["lucide-microscope"] = "rbxassetid://10734889106",
	["lucide-microwave"] = "rbxassetid://10734895076",
	["lucide-milestone"] = "rbxassetid://10734895310",
	["lucide-minimize"] = "rbxassetid://10734895698",
	["lucide-minimize-2"] = "rbxassetid://10734895530",
	["lucide-minus"] = "rbxassetid://10734896206",
	["lucide-minus-circle"] = "rbxassetid://10734895856",
	["lucide-minus-square"] = "rbxassetid://10734896029",
	["lucide-monitor"] = "rbxassetid://10734896881",
	["lucide-monitor-off"] = "rbxassetid://10734896360",
	["lucide-monitor-speaker"] = "rbxassetid://10734896512",
	["lucide-moon"] = "rbxassetid://10734897102",
	["lucide-more-horizontal"] = "rbxassetid://10734897250",
	["lucide-more-vertical"] = "rbxassetid://10734897387",
	["lucide-mountain"] = "rbxassetid://10734897956",
	["lucide-mountain-snow"] = "rbxassetid://10734897665",
	["lucide-mouse"] = "rbxassetid://10734898592",
	["lucide-mouse-pointer"] = "rbxassetid://10734898476",
	["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
	["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
	["lucide-move"] = "rbxassetid://10734900011",
	["lucide-move-3d"] = "rbxassetid://10734898756",
	["lucide-move-diagonal"] = "rbxassetid://10734899164",
	["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
	["lucide-move-horizontal"] = "rbxassetid://10734899414",
	["lucide-move-vertical"] = "rbxassetid://10734899821",
	["lucide-music"] = "rbxassetid://10734905958",
	["lucide-music-2"] = "rbxassetid://10734900215",
	["lucide-music-3"] = "rbxassetid://10734905665",
	["lucide-music-4"] = "rbxassetid://10734905823",
	["lucide-navigation"] = "rbxassetid://10734906744",
	["lucide-navigation-2"] = "rbxassetid://10734906332",
	["lucide-navigation-2-off"] = "rbxassetid://10734906144",
	["lucide-navigation-off"] = "rbxassetid://10734906580",
	["lucide-network"] = "rbxassetid://10734906975",
	["lucide-newspaper"] = "rbxassetid://10734907168",
	["lucide-octagon"] = "rbxassetid://10734907361",
	["lucide-option"] = "rbxassetid://10734907649",
	["lucide-outdent"] = "rbxassetid://10734907933",
	["lucide-package"] = "rbxassetid://10734909540",
	["lucide-package-2"] = "rbxassetid://10734908151",
	["lucide-package-check"] = "rbxassetid://10734908384",
	["lucide-package-minus"] = "rbxassetid://10734908626",
	["lucide-package-open"] = "rbxassetid://10734908793",
	["lucide-package-plus"] = "rbxassetid://10734909016",
	["lucide-package-search"] = "rbxassetid://10734909196",
	["lucide-package-x"] = "rbxassetid://10734909375",
	["lucide-paint-bucket"] = "rbxassetid://10734909847",
	["lucide-paintbrush"] = "rbxassetid://10734910187",
	["lucide-paintbrush-2"] = "rbxassetid://10734910030",
	["lucide-palette"] = "rbxassetid://10734910430",
	["lucide-palmtree"] = "rbxassetid://10734910680",
	["lucide-paperclip"] = "rbxassetid://10734910927",
	["lucide-party-popper"] = "rbxassetid://10734918735",
	["lucide-pause"] = "rbxassetid://10734919336",
	["lucide-pause-circle"] = "rbxassetid://10735024209",
	["lucide-pause-octagon"] = "rbxassetid://10734919143",
	["lucide-pen-tool"] = "rbxassetid://10734919503",
	["lucide-pencil"] = "rbxassetid://10734919691",
	["lucide-percent"] = "rbxassetid://10734919919",
	["lucide-person-standing"] = "rbxassetid://10734920149",
	["lucide-phone"] = "rbxassetid://10734921524",
	["lucide-phone-call"] = "rbxassetid://10734920305",
	["lucide-phone-forwarded"] = "rbxassetid://10734920508",
	["lucide-phone-incoming"] = "rbxassetid://10734920694",
	["lucide-phone-missed"] = "rbxassetid://10734920845",
	["lucide-phone-off"] = "rbxassetid://10734921077",
	["lucide-phone-outgoing"] = "rbxassetid://10734921288",
	["lucide-pie-chart"] = "rbxassetid://10734921727",
	["lucide-piggy-bank"] = "rbxassetid://10734921935",
	["lucide-pin"] = "rbxassetid://10734922324",
	["lucide-pin-off"] = "rbxassetid://10734922180",
	["lucide-pipette"] = "rbxassetid://10734922497",
	["lucide-pizza"] = "rbxassetid://10734922774",
	["lucide-plane"] = "rbxassetid://10734922971",
	["lucide-play"] = "rbxassetid://10734923549",
	["lucide-play-circle"] = "rbxassetid://10734923214",
	["lucide-plus"] = "rbxassetid://10734924532",
	["lucide-plus-circle"] = "rbxassetid://10734923868",
	["lucide-plus-square"] = "rbxassetid://10734924219",
	["lucide-podcast"] = "rbxassetid://10734929553",
	["lucide-pointer"] = "rbxassetid://10734929723",
	["lucide-pound-sterling"] = "rbxassetid://10734929981",
	["lucide-power"] = "rbxassetid://10734930466",
	["lucide-power-off"] = "rbxassetid://10734930257",
	["lucide-printer"] = "rbxassetid://10734930632",
	["lucide-puzzle"] = "rbxassetid://10734930886",
	["lucide-quote"] = "rbxassetid://10734931234",
	["lucide-radio"] = "rbxassetid://10734931596",
	["lucide-radio-receiver"] = "rbxassetid://10734931402",
	["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
	["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
	["lucide-recycle"] = "rbxassetid://10734932295",
	["lucide-redo"] = "rbxassetid://10734932822",
	["lucide-redo-2"] = "rbxassetid://10734932586",
	["lucide-refresh-ccw"] = "rbxassetid://10734933056",
	["lucide-refresh-cw"] = "rbxassetid://10734933222",
	["lucide-refrigerator"] = "rbxassetid://10734933465",
	["lucide-regex"] = "rbxassetid://10734933655",
	["lucide-repeat"] = "rbxassetid://10734933966",
	["lucide-repeat-1"] = "rbxassetid://10734933826",
	["lucide-reply"] = "rbxassetid://10734934252",
	["lucide-reply-all"] = "rbxassetid://10734934132",
	["lucide-rewind"] = "rbxassetid://10734934347",
	["lucide-rocket"] = "rbxassetid://10734934585",
	["lucide-rocking-chair"] = "rbxassetid://10734939942",
	["lucide-rotate-3d"] = "rbxassetid://10734940107",
	["lucide-rotate-ccw"] = "rbxassetid://10734940376",
	["lucide-rotate-cw"] = "rbxassetid://10734940654",
	["lucide-rss"] = "rbxassetid://10734940825",
	["lucide-ruler"] = "rbxassetid://10734941018",
	["lucide-russian-ruble"] = "rbxassetid://10734941199",
	["lucide-sailboat"] = "rbxassetid://10734941354",
	["lucide-save"] = "rbxassetid://10734941499",
	["lucide-scale"] = "rbxassetid://10734941912",
	["lucide-scale-3d"] = "rbxassetid://10734941739",
	["lucide-scaling"] = "rbxassetid://10734942072",
	["lucide-scan"] = "rbxassetid://10734942565",
	["lucide-scan-face"] = "rbxassetid://10734942198",
	["lucide-scan-line"] = "rbxassetid://10734942351",
	["lucide-scissors"] = "rbxassetid://10734942778",
	["lucide-screen-share"] = "rbxassetid://10734943193",
	["lucide-screen-share-off"] = "rbxassetid://10734942967",
	["lucide-scroll"] = "rbxassetid://10734943448",
	["lucide-search"] = "rbxassetid://10734943674",
	["lucide-send"] = "rbxassetid://10734943902",
	["lucide-separator-horizontal"] = "rbxassetid://10734944115",
	["lucide-separator-vertical"] = "rbxassetid://10734944326",
	["lucide-server"] = "rbxassetid://10734949856",
	["lucide-server-cog"] = "rbxassetid://10734944444",
	["lucide-server-crash"] = "rbxassetid://10734944554",
	["lucide-server-off"] = "rbxassetid://10734944668",
	["lucide-settings"] = "rbxassetid://10734950309",
	["lucide-settings-2"] = "rbxassetid://10734950020",
	["lucide-share"] = "rbxassetid://10734950813",
	["lucide-share-2"] = "rbxassetid://10734950553",
	["lucide-sheet"] = "rbxassetid://10734951038",
	["lucide-shield"] = "rbxassetid://10734951847",
	["lucide-shield-alert"] = "rbxassetid://10734951173",
	["lucide-shield-check"] = "rbxassetid://10734951367",
	["lucide-shield-close"] = "rbxassetid://10734951535",
	["lucide-shield-off"] = "rbxassetid://10734951684",
	["lucide-shirt"] = "rbxassetid://10734952036",
	["lucide-shopping-bag"] = "rbxassetid://10734952273",
	["lucide-shopping-cart"] = "rbxassetid://10734952479",
	["lucide-shovel"] = "rbxassetid://10734952773",
	["lucide-shower-head"] = "rbxassetid://10734952942",
	["lucide-shrink"] = "rbxassetid://10734953073",
	["lucide-shrub"] = "rbxassetid://10734953241",
	["lucide-shuffle"] = "rbxassetid://10734953451",
	["lucide-sidebar"] = "rbxassetid://10734954301",
	["lucide-sidebar-close"] = "rbxassetid://10734953715",
	["lucide-sidebar-open"] = "rbxassetid://10734954000",
	["lucide-sigma"] = "rbxassetid://10734954538",
	["lucide-signal"] = "rbxassetid://10734961133",
	["lucide-signal-high"] = "rbxassetid://10734954807",
	["lucide-signal-low"] = "rbxassetid://10734955080",
	["lucide-signal-medium"] = "rbxassetid://10734955336",
	["lucide-signal-zero"] = "rbxassetid://10734960878",
	["lucide-siren"] = "rbxassetid://10734961284",
	["lucide-skip-back"] = "rbxassetid://10734961526",
	["lucide-skip-forward"] = "rbxassetid://10734961809",
	["lucide-skull"] = "rbxassetid://10734962068",
	["lucide-slack"] = "rbxassetid://10734962339",
	["lucide-slash"] = "rbxassetid://10734962600",
	["lucide-slice"] = "rbxassetid://10734963024",
	["lucide-sliders"] = "rbxassetid://10734963400",
	["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
	["lucide-smartphone"] = "rbxassetid://10734963940",
	["lucide-smartphone-charging"] = "rbxassetid://10734963671",
	["lucide-smile"] = "rbxassetid://10734964441",
	["lucide-smile-plus"] = "rbxassetid://10734964188",
	["lucide-snowflake"] = "rbxassetid://10734964600",
	["lucide-sofa"] = "rbxassetid://10734964852",
	["lucide-sort-asc"] = "rbxassetid://10734965115",
	["lucide-sort-desc"] = "rbxassetid://10734965287",
	["lucide-speaker"] = "rbxassetid://10734965419",
	["lucide-sprout"] = "rbxassetid://10734965572",
	["lucide-square"] = "rbxassetid://10734965702",
	["lucide-star"] = "rbxassetid://10734966248",
	["lucide-star-half"] = "rbxassetid://10734965897",
	["lucide-star-off"] = "rbxassetid://10734966097",
	["lucide-stethoscope"] = "rbxassetid://10734966384",
	["lucide-sticker"] = "rbxassetid://10734972234",
	["lucide-sticky-note"] = "rbxassetid://10734972463",
	["lucide-stop-circle"] = "rbxassetid://10734972621",
	["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
	["lucide-stretch-vertical"] = "rbxassetid://10734973130",
	["lucide-strikethrough"] = "rbxassetid://10734973290",
	["lucide-subscript"] = "rbxassetid://10734973457",
	["lucide-sun"] = "rbxassetid://10734974297",
	["lucide-sun-dim"] = "rbxassetid://10734973645",
	["lucide-sun-medium"] = "rbxassetid://10734973778",
	["lucide-sun-moon"] = "rbxassetid://10734973999",
	["lucide-sun-snow"] = "rbxassetid://10734974130",
	["lucide-sunrise"] = "rbxassetid://10734974522",
	["lucide-sunset"] = "rbxassetid://10734974689",
	["lucide-superscript"] = "rbxassetid://10734974850",
	["lucide-swiss-franc"] = "rbxassetid://10734975024",
	["lucide-switch-camera"] = "rbxassetid://10734975214",
	["lucide-sword"] = "rbxassetid://10734975486",
	["lucide-swords"] = "rbxassetid://10734975692",
	["lucide-syringe"] = "rbxassetid://10734975932",
	["lucide-table"] = "rbxassetid://10734976230",
	["lucide-table-2"] = "rbxassetid://10734976097",
	["lucide-tablet"] = "rbxassetid://10734976394",
	["lucide-tag"] = "rbxassetid://10734976528",
	["lucide-tags"] = "rbxassetid://10734976739",
	["lucide-target"] = "rbxassetid://10734977012",
	["lucide-tent"] = "rbxassetid://10734981750",
	["lucide-terminal"] = "rbxassetid://10734982144",
	["lucide-terminal-square"] = "rbxassetid://10734981995",
	["lucide-text-cursor"] = "rbxassetid://10734982395",
	["lucide-text-cursor-input"] = "rbxassetid://10734982297",
	["lucide-thermometer"] = "rbxassetid://10734983134",
	["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
	["lucide-thermometer-sun"] = "rbxassetid://10734982771",
	["lucide-thumbs-down"] = "rbxassetid://10734983359",
	["lucide-thumbs-up"] = "rbxassetid://10734983629",
	["lucide-ticket"] = "rbxassetid://10734983868",
	["lucide-timer"] = "rbxassetid://10734984606",
	["lucide-timer-off"] = "rbxassetid://10734984138",
	["lucide-timer-reset"] = "rbxassetid://10734984355",
	["lucide-toggle-left"] = "rbxassetid://10734984834",
	["lucide-toggle-right"] = "rbxassetid://10734985040",
	["lucide-tornado"] = "rbxassetid://10734985247",
	["lucide-toy-brick"] = "rbxassetid://10747361919",
	["lucide-train"] = "rbxassetid://10747362105",
	["lucide-trash"] = "rbxassetid://10747362393",
	["lucide-trash-2"] = "rbxassetid://10747362241",
	["lucide-tree-deciduous"] = "rbxassetid://10747362534",
	["lucide-tree-pine"] = "rbxassetid://10747362748",
	["lucide-trees"] = "rbxassetid://10747363016",
	["lucide-trending-down"] = "rbxassetid://10747363205",
	["lucide-trending-up"] = "rbxassetid://10747363465",
	["lucide-triangle"] = "rbxassetid://10747363621",
	["lucide-trophy"] = "rbxassetid://10747363809",
	["lucide-truck"] = "rbxassetid://10747364031",
	["lucide-tv"] = "rbxassetid://10747364593",
	["lucide-tv-2"] = "rbxassetid://10747364302",
	["lucide-type"] = "rbxassetid://10747364761",
	["lucide-umbrella"] = "rbxassetid://10747364971",
	["lucide-underline"] = "rbxassetid://10747365191",
	["lucide-undo"] = "rbxassetid://10747365484",
	["lucide-undo-2"] = "rbxassetid://10747365359",
	["lucide-unlink"] = "rbxassetid://10747365771",
	["lucide-unlink-2"] = "rbxassetid://10747397871",
	["lucide-unlock"] = "rbxassetid://10747366027",
	["lucide-upload"] = "rbxassetid://10747366434",
	["lucide-upload-cloud"] = "rbxassetid://10747366266",
	["lucide-usb"] = "rbxassetid://10747366606",
	["lucide-user"] = "rbxassetid://10747373176",
	["lucide-user-check"] = "rbxassetid://10747371901",
	["lucide-user-cog"] = "rbxassetid://10747372167",
	["lucide-user-minus"] = "rbxassetid://10747372346",
	["lucide-user-plus"] = "rbxassetid://10747372702",
	["lucide-user-x"] = "rbxassetid://10747372992",
	["lucide-users"] = "rbxassetid://10747373426",
	["lucide-utensils"] = "rbxassetid://10747373821",
	["lucide-utensils-crossed"] = "rbxassetid://10747373629",
	["lucide-venetian-mask"] = "rbxassetid://10747374003",
	["lucide-verified"] = "rbxassetid://10747374131",
	["lucide-vibrate"] = "rbxassetid://10747374489",
	["lucide-vibrate-off"] = "rbxassetid://10747374269",
	["lucide-video"] = "rbxassetid://10747374938",
	["lucide-video-off"] = "rbxassetid://10747374721",
	["lucide-view"] = "rbxassetid://10747375132",
	["lucide-voicemail"] = "rbxassetid://10747375281",
	["lucide-volume"] = "rbxassetid://10747376008",
	["lucide-volume-1"] = "rbxassetid://10747375450",
	["lucide-volume-2"] = "rbxassetid://10747375679",
	["lucide-volume-x"] = "rbxassetid://10747375880",
	["lucide-wallet"] = "rbxassetid://10747376205",
	["lucide-wand"] = "rbxassetid://10747376565",
	["lucide-wand-2"] = "rbxassetid://10747376349",
	["lucide-watch"] = "rbxassetid://10747376722",
	["lucide-waves"] = "rbxassetid://10747376931",
	["lucide-webcam"] = "rbxassetid://10747381992",
	["lucide-wifi"] = "rbxassetid://10747382504",
	["lucide-wifi-off"] = "rbxassetid://10747382268",
	["lucide-wind"] = "rbxassetid://10747382750",
	["lucide-wrap-text"] = "rbxassetid://10747383065",
	["lucide-wrench"] = "rbxassetid://10747383470",
	["lucide-x"] = "rbxassetid://10747384394",
	["lucide-x-circle"] = "rbxassetid://10747383819",
	["lucide-x-octagon"] = "rbxassetid://10747384037",
	["lucide-x-square"] = "rbxassetid://10747384217",
	["lucide-zoom-in"] = "rbxassetid://10747384552",
	["lucide-zoom-out"] = "rbxassetid://10747384679",
};

Fatality.WindowFlags = {};

function Fatality:IsMobile() : boolean
	return UserInputService.TouchEnabled;	
end;

function Fatality:RandomString() : string
	return string.char(math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102));	
end;

function Fatality:GetTextSize(Text : TextLabel,CustomFont: Enum.Font) : Vector2
	return TextService:GetTextSize(Text.Text,Text.TextSize,(Text.Font ~= Enum.Font.Unknown and Text.Font) or (CustomFont or Enum.Font.GothamMedium),Vector2.new(math.huge,math.huge));
end;

function Fatality:IsMouseOverFrame(Frame : Frame) : boolean
	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function Fatality:GetCalculatePosition(planePos: number, planeNormal: Vector3, rayOrigin: number, rayDirection: Vector3) : number
	local n: Vector3 = planeNormal;
	local d: Vector3 = rayDirection;
	local v: Vector3 = rayOrigin - planePos;

	local num: number = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den: number = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a: number = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function Fatality:CreateHover(Element : Frame,Callback : (boolean) -> any)
	Element.MouseEnter:Connect(function()
		Callback(true);
	end);

	Element.MouseLeave:Connect(function()
		Callback(false);
	end);
end;

function Fatality:GetIcon(name : string) : string
	return Fatality.Lucide['lucide-'..tostring(name)] or Fatality.Lucide[name] or Fatality.Lucide[tostring(name)] or "";
end;

function Fatality:SetIcon(name : string, value : string)
	Fatality.Lucide[name] = value;
end;

function Fatality:Rounding(num: number, numDecimalPlaces: number) : number
	local mult: number = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;

function Fatality:CreateAnimation(Instance: Instance , Time: number , Style : Enum.EasingStyle , Property : {[string] : any}) : Tween
	if not Property then
		if typeof(Style) == 'table' then
			Property = Style;
			Style = nil;
		end;
	end;

	local Tween: Tween = TweenService:Create(Instance,TweenInfo.new(Time or 1 , Style or Enum.EasingStyle.Quint),Property);

	Tween:Play();

	return Tween;
end;

function Fatality:NewInput(Frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;

	if Callback then
		Button.MouseButton1Click:Connect(Callback);
	end;

	return Button;
end;

function Fatality:Drag(InputFrame: Frame, MoveFrame: Frame, Speed : number, IgnoreBlacklist: boolean)
	local dragging: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and (IgnoreBlacklist or #Fatality.DragBlacklist <= 0) then
			dragging = true;
			dragStart = input.Position;
			startPos = MoveFrame.Position;
		end;
	end);

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart;
			local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);

			if Speed and Speed > 0 then
				Fatality:CreateAnimation(MoveFrame,Speed,nil,{
					Position = position
				});
			else
				MoveFrame.Position = position;
			end;
		end;
	end);

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false;
		end;
	end);
end;

function Fatality:ScrollSignal(Scroll: ScrollingFrame,UIListLayout: UIListLayout,Type:string)
	if Type == 'X' then
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(UIListLayout.AbsoluteContentSize.X,0)
		end)
	else
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Scroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
		end)
	end;
end;

function Fatality:CreateResponse(args: {[string] : (any) -> any})
	local main = {};

	for i,v in next , args do
		if typeof(v) == 'function' then
			main[i] = function(self , ...)
				return v(...);
			end;
		else
			main[i] = v;
		end;
	end;

	return main;
end;

function Fatality:GetWindowFromElement(Element: GuiObject)
	for i,v in next , Fatality.Windows do
		if Element:IsDescendantOf(v) then
			return v;
		end;
	end;
end;

function Fatality:CreateOption(OptionButton: ImageButton): Elements
	Fatality:CreateHover(OptionButton,function(bool)
		if bool then
			Fatality:CreateAnimation(OptionButton,0.5,{
				ImageTransparency = 0.3
			})
		else
			Fatality:CreateAnimation(OptionButton,0.5,{
				ImageTransparency = 0.600
			})
		end;
	end);

	local Bindable = Instance.new('BindableEvent');
	local OwnWindow = Fatality:GetWindowFromElement(OptionButton);
	local ExtElementFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SpaceBox = Instance.new("Frame")

	Fatality:ScrollSignal(ScrollingFrame,UIListLayout,'Y');

	ExtElementFrame.Active = true;
	ExtElementFrame.Name = Fatality:RandomString()
	ExtElementFrame.Parent = OwnWindow
	ExtElementFrame.AnchorPoint = Vector2.new(0.5, 0)
	ExtElementFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ExtElementFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExtElementFrame.BorderSizePixel = 0
	ExtElementFrame.ClipsDescendants = true
	ExtElementFrame.Position = UDim2.new(2, 0, 2, 0)
	ExtElementFrame.Size = UDim2.new(0, 200, 0, 0)
	ExtElementFrame.ZIndex = 100

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ExtElementFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ExtElementFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = ExtElementFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = ExtElementFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = false
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, 0, 1, -5)
	ScrollingFrame.ZIndex = 109
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	SpaceBox.Name = Fatality:RandomString()
	SpaceBox.Parent = ScrollingFrame
	SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpaceBox.BorderSizePixel = 0
	SpaceBox.Size = UDim2.new(0, 0, 0, 3)

	local SPAWN_THREAD;

	local ToggleExt = function(bool)
		if bool then
			Bindable:SetAttribute('V',true);
			Bindable:Fire(true);

			local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,200)

			ExtElementFrame.Position = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2))

			Fatality:CreateAnimation(ExtElementFrame,0.45,{
				Size = UDim2.new(0, 200, 0, size)
			})

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 0.750
			})

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 0
			})

			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait(0.1)
					local size = math.clamp(UIListLayout.AbsoluteContentSize.Y + 15,0,200)
					local ud = UDim2.fromOffset(OptionButton.AbsolutePosition.X + 100, OptionButton.AbsolutePosition.Y + (size / 2));

					Fatality:CreateAnimation(ExtElementFrame,0.35,{
						Position = ud
					});
				end;
			end)
		else
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			Bindable:SetAttribute('V',false);
			Bindable:Fire(false);

			Fatality:CreateAnimation(ExtElementFrame,0.45,{
				Size = UDim2.new(0, 200, 0, 0)
			})

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 1
			})
		end;
	end;

	Bindable:SetAttribute('V',false);

	ToggleExt(false);

	OptionButton.MouseButton1Click:Connect(function()
		ToggleExt(true);
	end);

	UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			if not Fatality:IsMouseOverFrame(ExtElementFrame) and not Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER then
				ToggleExt(false);
			end;
		end;
	end);

	local UIElements: Elements = Fatality:CreateElements(ScrollingFrame,ScrollingFrame.ZIndex,Bindable);

	return UIElements;
end;

function Fatality:CreateColorPicker(ColorBox: Frame,Transparency, Callback)
	Transparency = Transparency or 0;
	Callback = Callback or function() end;

	local OwnWindow = Fatality:GetWindowFromElement(ColorBox);
	local ColorPickerFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ColorPickBox = Instance.new("ImageLabel")
	local MouseMovement = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorRedGreenBlue = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local ColorRGBSlide = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local ColorOpc = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local ColorOptSlide = Instance.new("Frame")
	local UIStroke_4 = Instance.new("UIStroke")
	local UIGradient_2 = Instance.new("UIGradient")
	local UIStroke_5 = Instance.new("UIStroke")
	local ColorOpt = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local PasteButton = Instance.new("ImageButton")
	local CopyButton = Instance.new("ImageButton")
	local hexCode = Instance.new("Frame")
	local UICorner_6 = Instance.new("UICorner")
	local HexCodeText = Instance.new("TextLabel")

	local OldCode = 0;
	local CodeH,CodeV = 1, 1;
	local IsPressM1 = false;
	local UI_SPAWN_THREAD;

	local updateColor = function()
		local H , S , V = ColorBox.BackgroundColor3:ToHSV();

		OldCode = H;
		CodeH = S;
		CodeV = V;
	end;

	local VisibleToggle = function(value)
		if value then
			ColorPickBox.BackgroundColor3 = Color3.fromHSV(OldCode,1,1);
			ColorOpc.BackgroundColor3 = ColorBox.BackgroundColor3;

			HexCodeText.Text = "#" .. tostring(ColorPickBox.BackgroundColor3:ToHex())

			ColorPickerFrame.Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);

			updateColor();

			if UI_SPAWN_THREAD then
				task.cancel(UI_SPAWN_THREAD);
				UI_SPAWN_THREAD = nil;
			end;

			UI_SPAWN_THREAD = task.spawn(function()
				while true do task.wait()
					Fatality:CreateAnimation(ColorPickerFrame,0.35,{
						Position = UDim2.fromOffset(ColorBox.AbsolutePosition.X + (ColorPickerFrame.AbsoluteSize.X / 1.5),ColorBox.AbsolutePosition.Y);
					});
				end;
			end);

			Fatality:CreateAnimation(ColorRGBSlide,0.35,{
				Position = UDim2.new(0.5, 0, OldCode, 0)
			});

			Fatality:CreateAnimation(MouseMovement,0.35,{
				Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
			})

			Fatality:CreateAnimation(ColorOptSlide,0.35,{
				Position = UDim2.new(1- Transparency, 0, 0.5, 0)
			})

			Fatality:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 195),
			});

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 0
			});

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 0.75
			});

			Fatality:CreateAnimation(ColorPickBox,0.45,{
				ImageTransparency = 0,
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(MouseMovement,0.45,{
				ImageTransparency = 0,
			});

			Fatality:CreateAnimation(UIStroke_2,0.45,{
				Transparency = 0
			});

			Fatality:CreateAnimation(ColorRedGreenBlue,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(ColorRGBSlide,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(UIStroke_3,0.45,{
				Transparency = 0.75
			});

			Fatality:CreateAnimation(ColorOpc,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(ColorOptSlide,0.45,{
				BackgroundTransparency = 0
			});

			Fatality:CreateAnimation(UIStroke_4,0.45,{
				Transparency = 0.75
			});

			Fatality:CreateAnimation(UIStroke_5,0.45,{
				Transparency = 0
			});

			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.45
			});

			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.45
			});

			Fatality:CreateAnimation(hexCode,0.45,{
				BackgroundTransparency = 0.4
			});

			Fatality:CreateAnimation(HexCodeText,0.45,{
				TextTransparency = 0.45
			});
		else
			if UI_SPAWN_THREAD then
				task.cancel(UI_SPAWN_THREAD);
				UI_SPAWN_THREAD = nil;
			end;

			Fatality:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 0)
			});

			Fatality:CreateAnimation(UIStroke,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(DropShadow,0.45,{
				ImageTransparency = 1
			});

			Fatality:CreateAnimation(ColorPickBox,0.45,{
				ImageTransparency = 1,
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(MouseMovement,0.45,{
				ImageTransparency = 1,
			});

			Fatality:CreateAnimation(UIStroke_2,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(ColorRedGreenBlue,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(ColorRGBSlide,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(UIStroke_3,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(ColorOpc,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(ColorOptSlide,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(UIStroke_4,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(UIStroke_5,0.45,{
				Transparency = 1
			});

			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 1
			});

			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 1
			});

			Fatality:CreateAnimation(hexCode,0.45,{
				BackgroundTransparency = 1
			});

			Fatality:CreateAnimation(HexCodeText,0.45,{
				TextTransparency = 1
			});
		end;
	end;

	ColorPickerFrame.Active = true;
	ColorPickerFrame.Name = Fatality:RandomString()
	ColorPickerFrame.Parent = OwnWindow
	ColorPickerFrame.AnchorPoint = Vector2.new(0.5, 0)
	ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	ColorPickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerFrame.BorderSizePixel = 0
	ColorPickerFrame.ClipsDescendants = true
	ColorPickerFrame.Position = UDim2.new(4,0,4,0)
	ColorPickerFrame.Size = UDim2.new(0, 175, 0, 195)
	ColorPickerFrame.ZIndex = 200
	Fatality:AddDragBlacklist(ColorPickerFrame);

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ColorPickerFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ColorPickerFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = ColorPickerFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 199
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ColorPickBox.Name = Fatality:RandomString()
	ColorPickBox.Parent = ColorPickerFrame
	ColorPickBox.BackgroundColor3 = Color3.fromRGB(39, 255, 35)
	ColorPickBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickBox.BorderSizePixel = 0
	ColorPickBox.Position = UDim2.new(0, 7, 0, 7)
	ColorPickBox.Size = UDim2.new(0, 135, 0, 135)
	ColorPickBox.ZIndex = 201
	ColorPickBox.Image = "http://www.roblox.com/asset/?id=112554223509763"

	MouseMovement.Name = Fatality:RandomString()
	MouseMovement.Parent = ColorPickBox
	MouseMovement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MouseMovement.BackgroundTransparency = 1.000
	MouseMovement.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MouseMovement.BorderSizePixel = 0
	MouseMovement.Position = UDim2.new(0.822222233, 0, 0.0592592582, 0)
	MouseMovement.Size = UDim2.new(0, 12, 0, 12)
	MouseMovement.ZIndex = 205
	MouseMovement.Image = "rbxassetid://4805639000"
	MouseMovement.AnchorPoint = Vector2.new(0.5,0.5)

	UICorner_2.CornerRadius = UDim.new(0, 2)
	UICorner_2.Parent = ColorPickBox

	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_2.Parent = ColorPickBox

	ColorRedGreenBlue.Name = Fatality:RandomString()
	ColorRedGreenBlue.Parent = ColorPickerFrame
	ColorRedGreenBlue.AnchorPoint = Vector2.new(1, 0)
	ColorRedGreenBlue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRedGreenBlue.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRedGreenBlue.BorderSizePixel = 0
	ColorRedGreenBlue.Position = UDim2.new(1, -7, 0, 7)
	ColorRedGreenBlue.Size = UDim2.new(0, 20, 0, 135)
	ColorRedGreenBlue.ZIndex = 206

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Rotation = 90
	UIGradient.Parent = ColorRedGreenBlue

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = ColorRedGreenBlue

	ColorRGBSlide.Name = Fatality:RandomString()
	ColorRGBSlide.Parent = ColorRedGreenBlue
	ColorRGBSlide.AnchorPoint = Vector2.new(0.5, 0)
	ColorRGBSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorRGBSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorRGBSlide.BorderSizePixel = 0
	ColorRGBSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorRGBSlide.Size = UDim2.new(1, 5, 0, 2)
	ColorRGBSlide.ZIndex = 207

	UIStroke_3.Transparency = 0.750
	UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_3.Parent = ColorRGBSlide

	ColorOpc.Name = Fatality:RandomString()
	ColorOpc.Parent = ColorPickerFrame
	ColorOpc.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpc.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpc.BorderSizePixel = 0
	ColorOpc.Position = UDim2.new(0.5, 0, 0, 149)
	ColorOpc.Size = UDim2.new(1, -15, 0, 12)
	ColorOpc.ZIndex = 206

	UICorner_4.CornerRadius = UDim.new(0, 2)
	UICorner_4.Parent = ColorOpc

	ColorOptSlide.Name = Fatality:RandomString()
	ColorOptSlide.Parent = ColorOpc
	ColorOptSlide.AnchorPoint = Vector2.new(0, 0.5)
	ColorOptSlide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorOptSlide.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOptSlide.BorderSizePixel = 0
	ColorOptSlide.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorOptSlide.Size = UDim2.new(0, 2, 1, 5)
	ColorOptSlide.ZIndex = 207

	UIStroke_4.Transparency = 0.750
	UIStroke_4.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_4.Parent = ColorOptSlide

	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient_2.Parent = ColorOpc

	UIStroke_5.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_5.Parent = ColorOpc

	ColorOpt.Name = Fatality:RandomString()
	ColorOpt.Parent = ColorPickerFrame
	ColorOpt.AnchorPoint = Vector2.new(0.5, 0)
	ColorOpt.BackgroundColor3 = Color3.fromRGB(102, 255, 0)
	ColorOpt.BackgroundTransparency = 1.000
	ColorOpt.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorOpt.BorderSizePixel = 0
	ColorOpt.Position = UDim2.new(0.5, 0, 0, 169)
	ColorOpt.Size = UDim2.new(1, -15, 0, 18)
	ColorOpt.ZIndex = 206

	UICorner_5.CornerRadius = UDim.new(0, 2)
	UICorner_5.Parent = ColorOpt

	PasteButton.Name = Fatality:RandomString()
	PasteButton.Parent = ColorOpt
	PasteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PasteButton.BackgroundTransparency = 1.000
	PasteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PasteButton.BorderSizePixel = 0
	PasteButton.Size = UDim2.new(1, 0, 1, 0)
	PasteButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	PasteButton.ZIndex = 209
	PasteButton.Image = "rbxassetid://10709799288"
	PasteButton.ImageTransparency = 0.450

	CopyButton.Name = Fatality:RandomString()
	CopyButton.Parent = ColorOpt
	CopyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	CopyButton.BackgroundTransparency = 1.000
	CopyButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CopyButton.BorderSizePixel = 0
	CopyButton.Position = UDim2.new(0, 20, 0, 0)
	CopyButton.Size = UDim2.new(1, 0, 1, 0)
	CopyButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
	CopyButton.ZIndex = 209
	CopyButton.Image = "rbxassetid://10709798682"
	CopyButton.ImageTransparency = 0.450

	hexCode.Name = Fatality:RandomString()
	hexCode.Parent = ColorOpt
	hexCode.BackgroundColor3 = Fatality.Colors.Black
	hexCode.BackgroundTransparency = 0.400
	hexCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
	hexCode.BorderSizePixel = 0
	hexCode.Position = UDim2.new(0, 43, 0, 0)
	hexCode.Size = UDim2.new(1, -43, 1, 0)
	hexCode.ZIndex = 209

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = hexCode

	HexCodeText.Name = Fatality:RandomString()
	HexCodeText.Parent = hexCode
	HexCodeText.AnchorPoint = Vector2.new(0, 0.5)
	HexCodeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HexCodeText.BackgroundTransparency = 1.000
	HexCodeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HexCodeText.BorderSizePixel = 0
	HexCodeText.Position = UDim2.new(0, 3, 0.5, 0)
	HexCodeText.Size = UDim2.new(1, 0, 0.800000012, 0)
	HexCodeText.ZIndex = 209
	HexCodeText.FontFace = Fatality.FontSemiBold
	HexCodeText.Text = "#fff"
	HexCodeText.TextColor3 = Color3.fromRGB(255, 255, 255)
	HexCodeText.TextSize = 13.000
	HexCodeText.TextTransparency = 0.450
	HexCodeText.TextXAlignment = Enum.TextXAlignment.Left;

	Fatality:CreateHover(CopyButton,function(bool)
		if bool then
			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.1
			})
		else
			Fatality:CreateAnimation(CopyButton,0.45,{
				ImageTransparency = 0.45
			})
		end
	end)	

	Fatality:CreateHover(PasteButton,function(bool)
		if bool then
			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.1
			})
		else
			Fatality:CreateAnimation(PasteButton,0.45,{
				ImageTransparency = 0.45
			})
		end
	end)

	PasteButton.MouseButton1Click:Connect(function()
		if Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY then
			local h,s,v = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHSV();

			Transparency = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.OPC;

			OldCode = h;
			CodeH = s;
			CodeV = v;

			HexCodeText.Text = "#" .. tostring(Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB:ToHex());

			Fatality:CreateAnimation(ColorRGBSlide,0.35,{
				Position = UDim2.new(0.5, 0, OldCode, 0)
			});

			Fatality:CreateAnimation(MouseMovement,0.35,{
				Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
			})

			Fatality:CreateAnimation(ColorOptSlide,0.35,{
				Position = UDim2.new(1- Transparency, 0, 0.5, 0)
			})

			Fatality:CreateAnimation(ColorPickerFrame,0.45,{
				Size = UDim2.new(0, 175, 0, 195),
			});

			ColorPickBox.BackgroundColor3 = Color3.fromHSV(h,1,1);

			ColorOpc.BackgroundColor3 = Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY.RGB;

			Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency);
		end;
	end);

	CopyButton.MouseButton1Click:Connect(function()
		Fatality.GLOBAL_ENVIRONMENT.COLOR_COPY = {
			RGB = Color3.fromHSV(OldCode,CodeH,CodeV),
			OPC = Transparency,
		};
	end)

	VisibleToggle(false);

	Fatality:NewInput(ColorBox,function()
		VisibleToggle(true);
	end);

	do
		local SPAWN_THREAD;
		ColorPickerFrame.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = true;

				if SPAWN_THREAD then
					task.cancel(SPAWN_THREAD);
					SPAWN_THREAD = nil;
				end;

				SPAWN_THREAD = task.spawn(function()
					while IsPressM1 do task.wait(0)
						Callback(Color3.fromHSV(OldCode,CodeH,CodeV),Transparency);
					end;
				end);
			end;
		end)

		ColorPickerFrame.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = false;
				Fatality.GLOBAL_ENVIRONMENT.IS_HOLD_COLOR_PICKER = false;

				if SPAWN_THREAD then
					task.cancel(SPAWN_THREAD);
					SPAWN_THREAD = nil;
				end;
			end;
		end)

		UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not Fatality:IsMouseOverFrame(ColorPickerFrame) then
					VisibleToggle(false);
				end;
			end;
		end)

		ColorRedGreenBlue.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local ColorY = ColorRedGreenBlue.AbsolutePosition.Y
					local ColorYM = ColorY + ColorRedGreenBlue.AbsoluteSize.Y;
					local Value = math.clamp(Mouse.Y, ColorY, ColorYM)
					local Code = ((Value - ColorY) / (ColorYM - ColorY));

					local Color = Color3.fromHSV(Code, CodeH, CodeV);

					Fatality:CreateAnimation(ColorRGBSlide,0.35,{
						Position = UDim2.new(0.5, 0, Code, 0)
					});

					Fatality:CreateAnimation(ColorBox,0.5,{
						BackgroundColor3 = Color
					});

					Fatality:CreateAnimation(ColorOpc,0.35,{
						BackgroundColor3 = Color
					});

					Fatality:CreateAnimation(ColorPickBox,0.5,{
						BackgroundColor3 = Color3.fromHSV(Code, 1, 1)
					});

					HexCodeText.Text = "#" .. tostring(Color:ToHex())

					OldCode = Code;
				end;
			end;
		end);

		ColorOpc.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local transparency = math.clamp((((Mouse.X) - ColorOpc.AbsolutePosition.X) / ColorOpc.AbsoluteSize.X), 0, 1);

					Fatality:CreateAnimation(ColorOptSlide,0.35,{
						Position = UDim2.new(transparency, 0, 0.5, 0)
					});

					HexCodeText.Text = "#" .. tostring(ColorBox.BackgroundColor3:ToHex())

					Transparency = (1 - transparency);
				end;
			end;
		end);

		ColorPickBox.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait();
					local PosX = ColorPickBox.AbsolutePosition.X
					local ScaleX = PosX + ColorPickBox.AbsoluteSize.X
					local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), ColorPickBox.AbsolutePosition.Y
					local ScaleY = PosY + ColorPickBox.AbsoluteSize.Y
					local Vals = math.clamp(Mouse.Y, PosY, ScaleY)

					CodeH = (Value - PosX) / (ScaleX - PosX);
					CodeV = (1 - ((Vals - PosY) / (ScaleY - PosY)));

					Fatality:CreateAnimation(ColorBox,0.5,{
						BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV)
					});

					Fatality:CreateAnimation(ColorOpc,0.35,{
						BackgroundColor3 = Color3.fromHSV(OldCode, CodeH, CodeV)
					});

					HexCodeText.Text = "#" .. tostring(Color3.fromHSV(OldCode, CodeH, CodeV):ToHex())

					Fatality:CreateAnimation(MouseMovement,0.2,nil,{
						Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
					})
				end
			end
		end)
	end;

	return {
		set_opc = function(v)
			Transparency = v;
		end,
	}
end;

function Fatality:RandomStr(len: number): string
	local main = "";

	for i = 1 , len do
		local max = #Fatality.Ascii;
		local rand = math.random(1,max);

		main = main .. Fatality.Ascii:sub(rand,rand);
	end;

	return main;
end;

function Fatality:AddDragBlacklist(Frame: Frame)
	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseMovement then
			local finder = table.find(Fatality.DragBlacklist , Frame);

			if not finder then
				table.insert(Fatality.DragBlacklist , Frame);
			end;
		end;
	end);

	Frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseMovement then
			local finder = table.find(Fatality.DragBlacklist , Frame);

			if finder then
				table.remove(Fatality.DragBlacklist , finder);
			end;
		end;
	end);
end;

function Fatality:ProtectText(Label: TextLabel,Text: string)
	Label.RichText = true;

	local MainText = string.gsub(Text,'.',function(t)
		if not string.find(t,"[<>()\"']") then
			return string.format('<font %s="%s">%s</font>',Fatality:RandomStr(5),Fatality:RandomStr(5),t)
		end;
		return t;
	end);

	Label.Text = MainText;
end;

function Fatality:CreateDropdown(Parent: Frame, Default: string | {[string]: boolean}, Multiplier: boolean, AutoUpdate: boolean,Callback: (data: any) -> any)
	local Window = Fatality:GetWindowFromElement(Parent);
	local Data = {};
	local Selected = (Multiplier and {}) or nil;

	local DropdownItemFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local SPAWN_THREAD;

	Fatality:AddDragBlacklist(DropdownItemFrame);

	local Toggle = function(value)
		if value then
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			SPAWN_THREAD = task.spawn(function()
				while true do task.wait()
					local baseSize = UIListLayout.AbsoluteContentSize.Y + 10;

					DropdownItemFrame.Position = UDim2.fromOffset(Parent.AbsolutePosition.X,Parent.AbsolutePosition.Y + (Parent.AbsoluteSize.Y * 5))

					Fatality:CreateAnimation(DropdownItemFrame,0.35,{
						Size = UDim2.new(0, 175, 0, math.clamp(baseSize,0,200))
					})
				end;
			end)

			Fatality:CreateAnimation(UIStroke,0.35,{
				Transparency = 0
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 0.75
			})
		else
			if SPAWN_THREAD then
				task.cancel(SPAWN_THREAD);
				SPAWN_THREAD = nil;
			end;

			Fatality:CreateAnimation(DropdownItemFrame,0.35,{
				Size = UDim2.new(0, 175, 0, 0)
			})

			Fatality:CreateAnimation(UIStroke,0.35,{
				Transparency = 1
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 1
			})
		end;
	end;

	Toggle(false);

	DropdownItemFrame.Name = Fatality:RandomString()
	DropdownItemFrame.Parent = Window
	DropdownItemFrame.AnchorPoint = Vector2.new(0, 0)
	DropdownItemFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	DropdownItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownItemFrame.BorderSizePixel = 0
	DropdownItemFrame.ClipsDescendants = true
	DropdownItemFrame.Position = UDim2.new(4,0,4,0)
	DropdownItemFrame.Size = UDim2.new(0, 175, 0, 100)
	DropdownItemFrame.ZIndex = 100

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = DropdownItemFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = DropdownItemFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = DropdownItemFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 99
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = DropdownItemFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ClipsDescendants = false
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
	ScrollingFrame.ZIndex = 109
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 4)
	end)

	local new_button = function()
		local db_selected = Instance.new("TextButton")

		db_selected.Name = Fatality:RandomString()
		db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		db_selected.BackgroundTransparency = 1.000
		db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
		db_selected.BorderSizePixel = 0
		db_selected.Size = UDim2.new(1, 0, 0, 10)
		db_selected.ZIndex = 110
		db_selected.FontFace = Fatality.FontSemiBold
		db_selected.TextColor3 = Fatality.Colors.Main
		db_selected.TextSize = 12.000
		db_selected.TextXAlignment = Enum.TextXAlignment.Left

		return db_selected;
	end;

	local func;
	local res = Fatality:CreateResponse({
		set_data = function(v)
			Data = v;
		end,
		on_toggle = function(cb)
			func = cb;
		end,
		change_default = function(v)
			Default = v;
		end,
		refresh = function()
			for i,v in next , ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					v:Destroy();
				end;
			end;

			local selectedmem;

			if not Multiplier then
				Selected = nil;
			end;

			for i,v in next , Data do
				local bth = new_button();

				bth.Text = tostring(v);

				bth.Parent = ScrollingFrame;

				if Multiplier then
					if (typeof(Default) == 'table' and (Default[v] or table.find(Default,v))) or Default == v then
						Selected[v] = true
						bth.TextColor3 = Fatality.Colors.Main;
					else
						bth.TextColor3 = Color3.fromRGB(255, 255, 255);
						Selected[v] = false
					end

					bth.MouseButton1Click:Connect(function()
						Selected[v] = not Selected[v];

						if Selected[v] then
							bth.TextColor3 = Fatality.Colors.Main;
						else
							bth.TextColor3 = Color3.fromRGB(255, 255, 255);
						end;

						Callback(Selected);
					end)
				else
					if v == Default then
						selectedmem = bth;
						Selected = v;

						bth.TextColor3 = Fatality.Colors.Main;
					else
						bth.TextColor3 = Color3.fromRGB(255, 255, 255);
					end;

					bth.MouseButton1Click:Connect(function()
						if selectedmem then
							selectedmem.TextColor3 = Color3.fromRGB(255, 255, 255);
						end;

						bth.TextColor3 = Fatality.Colors.Main;
						selectedmem = bth;
						Selected = v;

						Callback(v);
					end)
				end;
			end;

			Callback(Selected);
		end,
	});

	Fatality:NewInput(Parent,function()
		if AutoUpdate then
			res:refresh();
		end;

		func(true);
		Toggle(true);
	end);

	UserInputService.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			if not Fatality:IsMouseOverFrame(DropdownItemFrame) then
				func(false);
				Toggle(false);
			end;
		end;
	end);

	return res;
end;

function Fatality:CreateElements(Parent : Frame , ZIndex : number , Event : BindableEvent,SearchAPI: {Path: string,Memory : (name:string) -> any}) : Elements
	local elements = {};
	local FatalWindow = Fatality:GetWindowFromElement(Parent);

	function elements:AddToggle(Config: Toggle)
		Config = Config or {};
		Config.Name = Config.Name or "Toggle";
		Config.Default = Config.Default or false;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(bool) end;
		Config.Flag = Config.Flag or nil;

		local Toggle = Instance.new("Frame")
		local Toggle_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ValueIcon = Instance.new("ImageLabel")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Toggle.Name = Fatality:RandomString()
		Toggle.Parent = Parent
		Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Toggle.BackgroundTransparency = 1.000
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.Size = UDim2.new(1, -25, 0, 17)
		Toggle.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Toggle);

		Toggle_Name.Name = Fatality:RandomString()
		Toggle_Name.Parent = Toggle
		Toggle_Name.AnchorPoint = Vector2.new(0, 0.5)
		Toggle_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Toggle_Name.BackgroundTransparency = 1.000
		Toggle_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle_Name.BorderSizePixel = 0
		Toggle_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Toggle_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Toggle_Name.ZIndex = ZIndex + 2
		Toggle_Name.FontFace = Fatality.FontSemiBold;
		Toggle_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Toggle_Name.TextSize = 13.000
		Toggle_Name.TextTransparency = 1
		Toggle_Name.TextXAlignment = Enum.TextXAlignment.Left;

		Fatality:ProtectText(Toggle_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Toggle
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		ValueFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
		ValueFrame.ZIndex = ZIndex + 2
		ValueFrame.BackgroundTransparency = 1;

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		ValueIcon.Name = Fatality:RandomString()
		ValueIcon.Parent = ValueFrame
		ValueIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueIcon.BackgroundTransparency = 1.000
		ValueIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueIcon.BorderSizePixel = 0
		ValueIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueIcon.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
		ValueIcon.ZIndex = ZIndex + 2
		ValueIcon.Image = "rbxassetid://10709790644"
		ValueIcon.ImageTransparency = 1;

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = Toggle
		OptionButton.AnchorPoint = Vector2.new(1, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(1, -25, 0.5, 0)
		OptionButton.Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 1
		OptionButton.ZIndex = ZIndex + 4
		OptionButton.Visible = Config.Option;

		local toggleImg = function(value)
			if value then
				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 0,
					ImageColor3 = Fatality.Colors.Main,
					Size = UDim2.new(0.8, 0, 0.8, 0),
					Rotation = 0,
				})
			else
				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(0.699999988, 0, 0.699999988, 0),
					Rotation = 15
				})
			end;
		end;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.600) or 1
				})

				toggleImg(Config.Default)

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0,
				})

				Fatality:CreateAnimation(Toggle_Name,0.45,{
					TextTransparency = 0.200
				})
			else
				Fatality:CreateAnimation(Toggle_Name,0.45,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1,
				})

				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
				})

				Fatality:CreateAnimation(ValueIcon,0.45,{
					ImageTransparency = 1,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))

		toggleImg(Config.Default);

		Fatality:CreateHover(ValueFrame,function(b)
			if not Config.Default then
				if b then
					Fatality:CreateAnimation(ValueIcon,0.45,{
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(0.7, 0, 0.7, 0),
						Rotation = 0
					})
				else
					Fatality:CreateAnimation(ValueIcon,0.45,{
						ImageTransparency = 1,
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						Size = UDim2.new(0.699999988, 0, 0.699999988, 0),
						Rotation = 15
					})
				end;
			end;
		end)

		Fatality:NewInput(ValueFrame,function()
			Config.Default = not Config.Default;
			toggleImg(Config.Default);
			Config.Callback(Config.Default)
		end);

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Toggle_Name.Text = new_name;
				Fatality:ProtectText(Toggle_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v)
				local IsSame = v == Config.Default;

				Config.Default = v;

				toggleImg(Config.Default);

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and (Config.Flag.."Toggle"),
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Toggle"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddSlider(Config: Slider)
		Config = Config or {};
		Config.Name = Config.Name or "Slider";
		Config.Type = Config.Type or "";
		Config.Default = Config.Default or 50;
		Config.Min = Config.Min or 0;
		Config.Max = Config.Max or 100;
		Config.Round = Config.Round or 0;
		Config.Risky = Config.Risky or false;
		Config.Option = Config.Option or false;
		Config.Callback = Config.Callback or function(number) end;
		Config.Flag = Config.Flag or nil;

		local Slider = Instance.new("Frame")
		local Slider_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local boxli = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Slider.Name = Fatality:RandomString()
		Slider.Parent = Parent
		Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.Size = UDim2.new(1, -25, 0, 17)
		Slider.ZIndex = ZIndex + 1

		Fatality:AddDragBlacklist(Slider);

		Slider_Name.Name = Fatality:RandomString()
		Slider_Name.Parent = Slider
		Slider_Name.AnchorPoint = Vector2.new(0, 0.5)
		Slider_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Slider_Name.BackgroundTransparency = 1.000
		Slider_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider_Name.BorderSizePixel = 0
		Slider_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Slider_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Slider_Name.ZIndex = ZIndex + 2
		Slider_Name.FontFace = Fatality.FontSemiBold
		Slider_Name.Text = Config.Name
		Slider_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Slider_Name.TextSize = 13.000
		Slider_Name.TextTransparency = 0.200
		Slider_Name.TextXAlignment = Enum.TextXAlignment.Left

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 85, 0.600000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option;
		OptionButton.ZIndex = ZIndex + 1;

		boxli.Name = Fatality:RandomString()
		boxli.Parent = ValueFrame
		boxli.BackgroundColor3 = Fatality.Colors.Main
		boxli.BorderColor3 = Color3.fromRGB(0, 0, 0)
		boxli.BorderSizePixel = 0
		boxli.Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
		boxli.ZIndex = ZIndex + 3

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = boxli

		ValueText.Name = Fatality:RandomString()
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 4
		ValueText.FontFace = Fatality.FontSemiBold
		ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));
		ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850;
		ValueText.TextTransparency = 0;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(boxli,0.45,{
					BackgroundTransparency = 0,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.600) or 1
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0,
				})

				Fatality:CreateAnimation(Slider_Name,0.45,{
					TextTransparency = 0.200
				})

				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0;
				})
			else
				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1;
				})

				Fatality:CreateAnimation(Slider_Name,0.45,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1,
				})

				Fatality:CreateAnimation(boxli,0.45,{
					BackgroundTransparency = 1,
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'))

		local IsHold = false;

		local function update(Input)
			local SizeScale = math.clamp((((Input.Position.X) - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X), 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = Fatality:Rounding(Main,Config.Round);
			local PositionX = UDim2.fromScale(SizeScale, 1);
			local normalized = (Value - Config.Min) / (Config.Max - Config.Min);

			TweenService:Create(boxli , TweenInfo.new(0.2),{
				Size = UDim2.new(normalized, 0, 1, 0)
			}):Play();

			Config.Default = Value;
			ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));

			Config.Callback(Value)
		end;

		do
			ValueFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					update(Input)
				end
			end)

			ValueFrame.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not Fatality:IsMouseOverFrame(ValueFrame) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not Fatality:IsMouseOverFrame(ValueFrame) then
								IsHold = false
							else
								update(Input)
							end;
						else
							update(Input)
						end;
					end;
				end;
			end);
		end;

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Slider_Name.Text = new_name
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v)
				local IsSame = v == Config.Default;

				Config.Default = v;

				TweenService:Create(boxli , TweenInfo.new(0.2),{
					Size = UDim2.new((Config.Default - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
				}):Play();

				Config.Default = v;
				ValueText.Text = string.format('%s%s',tostring(Config.Default),tostring(Config.Type));

				if not IsSame then
					Config.Callback(v);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."Slider",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Slider"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddButton(Config: Button)
		Config = Config or {};
		Config.Name = Config.Name or "Slider";
		Config.Risky = Config.Risky or false;
		Config.Callback = Config.Callback or function() end;

		local Button = Instance.new("Frame")
		local Button_Name = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Button.Name = Fatality:RandomString()
		Button.Parent = Parent
		Button.BackgroundColor3 = Fatality.Colors.Black
		Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button.BorderSizePixel = 0
		Button.Size = UDim2.new(1, -25, 0, 25)
		Button.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Button);

		Button_Name.Name = Fatality:RandomString()
		Button_Name.Parent = Button
		Button_Name.AnchorPoint = Vector2.new(0, 0.5)
		Button_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Button_Name.BackgroundTransparency = 1.000
		Button_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Button_Name.BorderSizePixel = 0
		Button_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Button_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Button_Name.ZIndex = ZIndex + 2
		Button_Name.FontFace = Fatality.FontSemiBold
		Button_Name.Text = Config.Name
		Button_Name.TextColor3 = (Config.Risky and Color3.fromRGB(255, 160, 92)) or Color3.fromRGB(255, 255, 255)
		Button_Name.TextSize = 12.000
		Button_Name.TextTransparency = 0.400
		Fatality:ProtectText(Button_Name,Config.Name);

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = Button;

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Button_Name,0.45,{
					TextTransparency = 0.4,
				})

				Fatality:CreateAnimation(Button,0.45,{
					BackgroundTransparency = 0,
				})
			else
				Fatality:CreateAnimation(Button_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(Button,0.45,{
					BackgroundTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		Fatality:CreateHover(Button,function(value)
			if value then
				Fatality:CreateAnimation(Button,0.45,{
					BackgroundColor3 = Color3.fromRGB(14, 14, 14)
				})
			else
				Fatality:CreateAnimation(Button,0.45,{
					BackgroundColor3 = Fatality.Colors.Black
				})
			end;
		end)

		Fatality:NewInput(Button,function()
			Config.Callback();
		end)

		return Fatality:CreateResponse({
			Rename = function(new_name)
				Button_Name.Text = new_name
				Fatality:ProtectText(Button_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			Fire = Config.Callback,
		})
	end;

	function elements:AddColorPicker(Config: ColorPicker)
		Config = Config or {};
		Config.Name = Config.Name or "Color Picker";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or Color3.fromRGB(255, 255, 255);
		Config.Callback = Config.Callback or function(number) end;
		Config.Transparency = Config.Transparency or 0;
		Config.Flag = Config.Flag or nil;

		local ColorPicker = Instance.new("Frame")
		local ColorPicker_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		ColorPicker.Name = Fatality:RandomString()
		ColorPicker.Parent = Parent
		ColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker.BackgroundTransparency = 1.000
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.Size = UDim2.new(1, -25, 0, 17)
		ColorPicker.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(ColorPicker);

		ColorPicker_Name.Name = Fatality:RandomString()
		ColorPicker_Name.Parent = ColorPicker
		ColorPicker_Name.AnchorPoint = Vector2.new(0, 0.5)
		ColorPicker_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker_Name.BackgroundTransparency = 1.000
		ColorPicker_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker_Name.BorderSizePixel = 0
		ColorPicker_Name.Position = UDim2.new(0, 0, 0.5, 0)
		ColorPicker_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		ColorPicker_Name.ZIndex = ZIndex + 2
		ColorPicker_Name.FontFace = Fatality.FontSemiBold
		ColorPicker_Name.Text = Config.Name
		ColorPicker_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		ColorPicker_Name.TextSize = 13.000
		ColorPicker_Name.TextTransparency = 0.200
		ColorPicker_Name.TextXAlignment = Enum.TextXAlignment.Left
		ColorPicker_Name.ZIndex = ZIndex + 2

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = ColorPicker
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Config.Default
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 35, 0.699999988, 0)
		ValueFrame.ZIndex = ZIndex + 3

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 7;

		local res = Fatality:CreateColorPicker(ValueFrame,Config.Transparency,function(rgb,opc)
			ValueFrame.BackgroundColor3 = rgb;
			ValueFrame.BackgroundTransparency = opc;

			task.spawn(Config.Callback,rgb,opc)
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(ColorPicker_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					Size = UDim2.new(0, 35, 0.7, 0)
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				Fatality:CreateAnimation(ColorPicker_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					Size = UDim2.new(0, 35, 0, 0)
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				ColorPicker.Text = new_name
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(rgb,opc)
				local IsSame = ValueFrame.BackgroundColor3 == rgb or ValueFrame.BackgroundTransparency == opc;

				ValueFrame.BackgroundColor3 = rgb; 
				ValueFrame.BackgroundTransparency = opc;
				res.set_opc(opc);

				if not IsSame then
					task.spawn(Config.Callback,rgb,opc)
				end;
			end,
			GetValue = function()
				return {
					Color = ValueFrame.BackgroundColor3,
					Transparency = ValueFrame.BackgroundTransparency
				};
			end,
			Flag = Config.Flag and Config.Flag.."ColorPicker",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."ColorPicker"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddDropdown(Config: Dropdown)
		Config = Config or {};
		Config.Name = Config.Name or "Dropdown";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;
		Config.Values = Config.Values or {};
		Config.Multi = Config.Multi or false;

		local DataParser = function(value)
			if not value then return 'None'; end;

			local Out;

			if typeof(value) == 'table' then
				if #value > 0 then
					local x = {};

					for i,v in next , value do
						table.insert(x , tostring(v))
					end;

					Out = table.concat(x,' , ');
				else
					local x = {};

					for i,v in next , value do
						if v == true then
							table.insert(x , tostring(i));
						end			
					end;

					Out = table.concat(x,' , ');
				end;
			else
				Out = tostring(value);
			end;

			return Out;
		end;

		local Dropdown = Instance.new("Frame")
		local Dropdown_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local icon = Instance.new("ImageLabel")
		local Value_Text = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Dropdown.Name = Fatality:RandomString()
		Dropdown.Parent = Parent
		Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown.BackgroundTransparency = 1.000
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.Size = UDim2.new(1, -25, 0, 17)
		Dropdown.ZIndex = ZIndex + 3
		Fatality:AddDragBlacklist(Dropdown);

		Dropdown_Name.Name = Fatality:RandomString()
		Dropdown_Name.Parent = Dropdown
		Dropdown_Name.AnchorPoint = Vector2.new(0, 0.5)
		Dropdown_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown_Name.BackgroundTransparency = 1.000
		Dropdown_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown_Name.BorderSizePixel = 0
		Dropdown_Name.Position = UDim2.new(0, 0, 0, 8)
		Dropdown_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Dropdown_Name.ZIndex = 7
		Dropdown_Name.FontFace = Fatality.FontSemiBold
		Dropdown_Name.Text = Config.Name
		Dropdown_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		Dropdown_Name.TextSize = 13.000
		Dropdown_Name.TextTransparency = 0.200
		Dropdown_Name.TextXAlignment = Enum.TextXAlignment.Left
		Dropdown_Name.ZIndex = ZIndex + 4
		Fatality:ProtectText(Dropdown_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Dropdown
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.925000012, 0)
		ValueFrame.ZIndex = ZIndex + 4

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0, 7)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.ZIndex = 8
		OptionButton.Visible = Config.Option;

		icon.Name = Fatality:RandomString()
		icon.Parent = ValueFrame
		icon.AnchorPoint = Vector2.new(1, 0)
		icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		icon.BackgroundTransparency = 1.000
		icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		icon.BorderSizePixel = 0
		icon.Position = UDim2.new(1, 0, 0, 0)
		icon.Size = UDim2.new(0,15,0,15)
		icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		icon.ZIndex = ZIndex + 5
		icon.Image = "rbxassetid://10709790948"

		Value_Text.Name = Fatality:RandomString()
		Value_Text.Parent = ValueFrame
		Value_Text.AnchorPoint = Vector2.new(0, 0.5)
		Value_Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Value_Text.BackgroundTransparency = 1.000
		Value_Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value_Text.BorderSizePixel = 0
		Value_Text.Position = UDim2.new(0, 3, 0.5, 0)
		Value_Text.Size = UDim2.new(1, -18, 0.800000012, 0)
		Value_Text.ZIndex = ZIndex + 5
		Value_Text.FontFace = Fatality.FontSemiBold
		Value_Text.Text = DataParser(Config.Default)
		Value_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
		Value_Text.TextSize = 10.000
		Value_Text.TextTransparency = 0.500
		Value_Text.TextXAlignment = Enum.TextXAlignment.Left
		Value_Text.TextYAlignment = Enum.TextYAlignment.Top
		Value_Text.TextWrapped = true
		Value_Text.TextTruncate = Enum.TextTruncate.SplitWord

		local res;
		res = Fatality:CreateDropdown(ValueFrame,Config.Default,Config.Multi,Config.AutoUpdate,function(args)
			Config.Default = args;
			Value_Text.Text = DataParser(Config.Default);

			res:change_default(Config.Default);

			Config.Callback(args);
		end);

		res:set_data(Config.Values);
		res:refresh();

		res:on_toggle(function(b)
			if b then
				Fatality:CreateAnimation(icon,0.35,{
					Rotation = -180,
					ImageColor3 = Fatality.Colors.Main
				})
			else
				Fatality:CreateAnimation(icon,0.35,{
					Rotation = 0,
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				})
			end;
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Dropdown_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(icon,0.45,{
					ImageTransparency = 0
				})

				Fatality:CreateAnimation(Value_Text,0.45,{
					TextTransparency = 0.5
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				Fatality:CreateAnimation(Dropdown_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(icon,0.45,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(Value_Text,0.45,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Dropdown_Name.Text = new_name
				Fatality:ProtectText(Dropdown_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)

				Config.Default = def;
				Value_Text.Text = DataParser(Config.Default);
				res:change_default(Config.Default);

				Config.Callback(def);
			end,
			SetData = function(def)
				Config.Values = def;

				res:set_data(Config.Values);

				if not Config.AutoUpdate then
					res:refresh();
				end
			end,
			Flag = Config.Flag and Config.Flag.."Dropdown",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."Dropdown"] = Respons;
		end;

		return Respons;
	end;
	
	function elements:AddKeybind(Config: Keybind)
		Config = Config or {};
		Config.Name = Config.Name or "Keybind";
		Config.Option = Config.Option or false;
		Config.Default = Config.Default or nil;
		Config.Callback = Config.Callback or function(any) end;

		local Keys = {
			One = '1',
			Two = '2',
			Three = '3',
			Four = '4',
			Five = '5',
			Six = '6',
			Seven = '7',
			Eight = '8',
			Nine = '9',
			Zero = '0',
			['Minus'] = "-",
			['Plus'] = "+",
			BackSlash = "\\",
			Slash = "/",
			Period = '.',
			Semicolon = ';',
			Colon = ":",
			LeftControl = "LCtrl",
			RightControl = "RCtrl",
			LeftShift = "LShift",
			RightShift = "RShift",
			Return = "Enter",
			LeftBracket = "[",
			RightBracket = "]",
			Quote = "'",
			Comma = ",",
			Equals = "=",
			LeftSuper = "Super",
			RightSuper = "Super"
		};

		local GetItem = function(item)
			if item then
				if typeof(item) == 'EnumItem' then
					return Keys[item.Name] or item.Name;
				else
					return Keys[tostring(item)] or tostring(item);
				end;
			else
				return 'None';
			end;
		end;

		local Keybind = Instance.new("Frame")
		local Keybind_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local OptionButton = Instance.new("ImageButton")
		local ValueText = Instance.new("TextLabel")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		Keybind.Name = Fatality:RandomString()
		Keybind.Parent = Parent
		Keybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Keybind.BackgroundTransparency = 1.000
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.Size = UDim2.new(1, -25, 0, 17)
		Keybind.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(Keybind);

		Keybind_Name.Name = Fatality:RandomString()
		Keybind_Name.Parent = Keybind
		Keybind_Name.AnchorPoint = Vector2.new(0, 0.5)
		Keybind_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Keybind_Name.BackgroundTransparency = 1.000
		Keybind_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind_Name.BorderSizePixel = 0
		Keybind_Name.Position = UDim2.new(0, 0, 0.5, 0)
		Keybind_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		Keybind_Name.ZIndex = ZIndex + 2
		Keybind_Name.FontFace = Fatality.FontSemiBold
		Keybind_Name.Text = Config.Name
		Keybind_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		Keybind_Name.TextSize = 13.000
		Keybind_Name.TextTransparency = 0.200
		Keybind_Name.TextXAlignment = Enum.TextXAlignment.Left
		Fatality:ProtectText(Keybind_Name,Config.Name);

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = Keybind
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 75, 0.850000024, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		OptionButton.Name = Fatality:RandomString()
		OptionButton.Parent = ValueFrame
		OptionButton.AnchorPoint = Vector2.new(0, 0.5)
		OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OptionButton.BackgroundTransparency = 1.000
		OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OptionButton.BorderSizePixel = 0
		OptionButton.Position = UDim2.new(0, -20, 0.5, 0)
		OptionButton.Size = UDim2.new(0, 13, 0, 13)
		OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
		OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
		OptionButton.ImageTransparency = 0.600
		OptionButton.Visible = Config.Option or false;

		ValueText.Name = Fatality:RandomString()
		ValueText.Parent = ValueFrame
		ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.BackgroundTransparency = 1.000
		ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueText.BorderSizePixel = 0
		ValueText.Size = UDim2.new(1, 0, 1, 0)
		ValueText.ZIndex = ZIndex + 3
		ValueText.FontFace = Fatality.FontSemiBold
		ValueText.Text = GetItem(Config.Default)
		ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueText.TextSize = 9.000
		ValueText.TextStrokeTransparency = 0.850
		ValueText.TextTransparency = 0.400

		local IsBinding = false;
		Fatality:NewInput(ValueFrame,function()
			if IsBinding then
				return;
			end;

			ValueText.Text = "...";

			local Selected = nil;
			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 then
						Selected = "MouseLeft";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then
						Selected = "MouseRight";
					end;
				end;
			end;

			Config.Default = Selected;

			ValueText.Text = GetItem(Selected);

			IsBinding = false;

			Config.Callback(typeof(Selected) == "string" and Selected or Selected.Name);
		end);

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(Keybind_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 0.850,
					TextTransparency = 0.400
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = (Config.Option and 0.6) or 1,
				})
			else
				Fatality:CreateAnimation(Keybind_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(ValueText,0.45,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})

				Fatality:CreateAnimation(OptionButton,0.45,{
					ImageTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				Keybind_Name.Text = new_name
				Fatality:ProtectText(Keybind_Name,new_name);
			end,
			GetValue = function()
				return Config.Default;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(def)
				local IsSame = Config.Default == def;

				Config.Default = def;
				ValueText.Text = GetItem(Config.Default);

				if not IsSame then
					Config.Callback(Config.Default);
				end;
			end,
			Flag = Config.Flag and Config.Flag.."Keybind",
			Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
		});

		if Config.Flag then

			Fatality.WindowFlags[FatalWindow][Config.Flag.."Keybind"] = Respons;
		end;

		return Respons;
	end;

	function elements:AddTextBox(Config)
		Config = Config or {};
		Config.Name = Config.Name or "Text Box";
		Config.Default = Config.Default or "";
		Config.Placeholder = Config.Placeholder or "Type here...";
		Config.Callback = Config.Callback or function(text) end;
		Config.Flag = Config.Flag or nil;

		local TextBoxItem = Instance.new("Frame")
		local TextBox_Name = Instance.new("TextLabel")
		local ValueFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Input = Instance.new("TextBox")

		if SearchAPI then
			SearchAPI.Memory(Config.Name);
		end;

		TextBoxItem.Name = Fatality:RandomString()
		TextBoxItem.Parent = Parent
		TextBoxItem.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBoxItem.BackgroundTransparency = 1.000
		TextBoxItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBoxItem.BorderSizePixel = 0
		TextBoxItem.Size = UDim2.new(1, -25, 0, 17)
		TextBoxItem.ZIndex = ZIndex + 1
		Fatality:AddDragBlacklist(TextBoxItem);

		TextBox_Name.Name = Fatality:RandomString()
		TextBox_Name.Parent = TextBoxItem
		TextBox_Name.AnchorPoint = Vector2.new(0, 0.5)
		TextBox_Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox_Name.BackgroundTransparency = 1.000
		TextBox_Name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox_Name.BorderSizePixel = 0
		TextBox_Name.Position = UDim2.new(0, 0, 0.5, 0)
		TextBox_Name.Size = UDim2.new(1, 0, 0.800000012, 0)
		TextBox_Name.ZIndex = ZIndex + 2
		TextBox_Name.FontFace = Fatality.FontSemiBold
		TextBox_Name.Text = Config.Name
		TextBox_Name.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox_Name.TextSize = 13.000
		TextBox_Name.TextTransparency = 0.200
		TextBox_Name.TextXAlignment = Enum.TextXAlignment.Left

		ValueFrame.Name = Fatality:RandomString()
		ValueFrame.Parent = TextBoxItem
		ValueFrame.AnchorPoint = Vector2.new(1, 0.5)
		ValueFrame.BackgroundColor3 = Fatality.Colors.Black
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.ClipsDescendants = true
		ValueFrame.Position = UDim2.new(1, -3, 0.5, 0)
		ValueFrame.Size = UDim2.new(0, 100, 0.925000012, 0)
		ValueFrame.ZIndex = ZIndex + 2

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = ValueFrame

		Input.Name = Fatality:RandomString()
		Input.Parent = ValueFrame
		Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Input.BackgroundTransparency = 1.000
		Input.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Input.BorderSizePixel = 0
		Input.Position = UDim2.new(0, 4, 0, 0)
		Input.Size = UDim2.new(1, -8, 1, 0)
		Input.ZIndex = ZIndex + 3
		Input.ClearTextOnFocus = false
		Input.FontFace = Fatality.FontSemiBold
		Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
		Input.PlaceholderText = Config.Placeholder
		Input.Text = tostring(Config.Default)
		Input.TextColor3 = Color3.fromRGB(255, 255, 255)
		Input.TextSize = 10.000
		Input.TextTransparency = 0.300
		Input.TextXAlignment = Enum.TextXAlignment.Left
		Input.ClipsDescendants = true

		local OpcToggle = function(value)
			if value then
				Fatality:CreateAnimation(TextBox_Name,0.45,{
					TextTransparency = 0.2,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 0,
				})

				Fatality:CreateAnimation(Input,0.45,{
					TextTransparency = 0.3,
				})
			else
				Fatality:CreateAnimation(TextBox_Name,0.45,{
					TextTransparency = 1,
				})

				Fatality:CreateAnimation(ValueFrame,0.45,{
					BackgroundTransparency = 1,
				})

				Fatality:CreateAnimation(Input,0.45,{
					TextTransparency = 1,
				})
			end;
		end;

		OpcToggle(Event:GetAttribute('V'));

		Input.FocusLost:Connect(function()
			Config.Default = Input.Text;
			Config.Callback(Input.Text);
		end);

		local Respons = Fatality:CreateResponse({
			Rename = function(new_name)
				TextBox_Name.Text = new_name;
			end,
			GetValue = function()
				return Input.Text;
			end,
			Signal = Event.Event:Connect(OpcToggle),
			SetValue = function(v)
				v = tostring(v or "");

				local IsSame = v == Input.Text;

				Input.Text = v;
				Config.Default = v;

				if not IsSame then
					Config.Callback(v);
				end;
			end,
			Flag = Config.Flag and (Config.Flag.."TextBox"),
		});

		if Config.Flag then
			Fatality.WindowFlags[FatalWindow][Config.Flag.."TextBox"] = Respons;
		end;

		return Respons;
	end;

	return elements;
end;

function Fatality:CreateConfigWindow(Root: ScreenGui , Fatal , Button: ImageButton)

	local ConfigWindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local DropShadow = Instance.new("ImageLabel")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local UIListLayout = Instance.new("UIListLayout")
	local SpaceBox = Instance.new("Frame")
	local InputFrame = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_3 = Instance.new("UICorner")
	local TextBox = Instance.new("TextBox")
	local AddConfigButton = Instance.new("ImageButton")
	local UICorner_4 = Instance.new("UICorner")
	local GetConfigButton = Instance.new("ImageButton")
	local UICorner_5 = Instance.new("UICorner")
	local SaveConfigButton = Instance.new("ImageButton")
	local UICorner_6 = Instance.new("UICorner")
	local DeleteButton = Instance.new("ImageButton")
	local UICorner_7 = Instance.new("UICorner")

	Fatality:ScrollSignal(ScrollingFrame,UIListLayout,"Y");

	Fatality:AddDragBlacklist(ConfigWindowFrame);

	local UIToggle = false;
	local ElementToggle = function(value)
		UIToggle = value;

		if value then
			ConfigWindowFrame.Position = UDim2.fromOffset(Button.AbsolutePosition.X,Button.AbsolutePosition.Y + (Button.AbsoluteSize.Y * 3));

			Fatality:CreateAnimation(ConfigWindowFrame,0.3,{
				Size = UDim2.new(0, 185, 0, 195),
			})

			Fatality:CreateAnimation(UIStroke,0.3,{
				Transparency = 0
			})

			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 0.750
			})

			Fatality:CreateAnimation(ScrollingFrame,0.3,{
				BackgroundTransparency = 0
			})

			Fatality:CreateAnimation(UIStroke_2,0.3,{
				Transparency = 0.750
			})

			Fatality:CreateAnimation(UIStroke_3,0.3,{
				Transparency = 0.750
			})

			Fatality:CreateAnimation(SpaceBox,0.3,{
				BackgroundTransparency = 0
			})

			Fatality:CreateAnimation(InputFrame,0.3,{
				BackgroundTransparency = 0
			})

			Fatality:CreateAnimation(TextBox,0.3,{
				TextTransparency = 0.5
			})

			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.500
			})

			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0.2500
			})

			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 0.75
			})
		else
			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(ConfigWindowFrame,0.275,{
				Size = UDim2.new(0, 185, 0, 0),
			})

			Fatality:CreateAnimation(UIStroke,0.3,{
				Transparency = 1
			})

			Fatality:CreateAnimation(DropShadow,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(ScrollingFrame,0.3,{
				BackgroundTransparency = 1
			})

			Fatality:CreateAnimation(UIStroke_2,0.3,{
				Transparency = 1
			})

			Fatality:CreateAnimation(UIStroke_3,0.3,{
				Transparency = 1
			})

			Fatality:CreateAnimation(SpaceBox,0.3,{
				BackgroundTransparency = 1
			})

			Fatality:CreateAnimation(InputFrame,0.3,{
				BackgroundTransparency = 1
			})

			Fatality:CreateAnimation(TextBox,0.3,{
				TextTransparency = 1
			})

			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 1
			})
		end;
	end;

	ElementToggle(false);

	ConfigWindowFrame.Name = "ConfigWindowFrame"
	ConfigWindowFrame.Parent = Root
	ConfigWindowFrame.AnchorPoint = Vector2.new(0,1)
	ConfigWindowFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	ConfigWindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigWindowFrame.BorderSizePixel = 0
	ConfigWindowFrame.ClipsDescendants = true
	ConfigWindowFrame.Position = UDim2.new(2,0,2,0)
	ConfigWindowFrame.Size = UDim2.new(0, 185, 0, 0)
	ConfigWindowFrame.ZIndex = 205

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ConfigWindowFrame

	UIStroke.Color = Color3.fromRGB(29, 29, 29)
	UIStroke.Parent = ConfigWindowFrame

	DropShadow.Name = "DropShadow"
	DropShadow.Parent = ConfigWindowFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Rotation = 0.001
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = 205
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 0.750
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

	ScrollingFrame.Parent = ConfigWindowFrame
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = Fatality.Colors.Black
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0, 8, 0, 8)
	ScrollingFrame.Size = UDim2.new(1, -40, 1, -45)
	ScrollingFrame.ZIndex = 207
	ScrollingFrame.ScrollBarThickness = 0

	UICorner_2.CornerRadius = UDim.new(0, 3)
	UICorner_2.Parent = ScrollingFrame

	UIStroke_2.Transparency = 0.750
	UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_2.Parent = ScrollingFrame

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	SpaceBox.Name = "SpaceBox"
	SpaceBox.Parent = ScrollingFrame
	SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SpaceBox.BorderSizePixel = 0
	SpaceBox.Size = UDim2.new(0, 0, 0, 1)

	InputFrame.Name = "InputFrame"
	InputFrame.Parent = ConfigWindowFrame
	InputFrame.AnchorPoint = Vector2.new(0, 1)
	InputFrame.BackgroundColor3 = Fatality.Colors.Black
	InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	InputFrame.BorderSizePixel = 0
	InputFrame.Position = UDim2.new(0, 8, 1, -9)
	InputFrame.Size = UDim2.new(1, -40, 0, 22)
	InputFrame.ZIndex = 208

	UIStroke_3.Transparency = 0.750
	UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
	UIStroke_3.Parent = InputFrame

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = InputFrame

	TextBox.Parent = InputFrame
	TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextBox.Size = UDim2.new(1, -10, 1, -1)
	TextBox.ZIndex = 209
	TextBox.FontFace = Fatality.FontSemiBold
	TextBox.Text = ""
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.TextSize = 10.000
	TextBox.TextTransparency = 0.500
	TextBox.TextXAlignment = Enum.TextXAlignment.Left

	AddConfigButton.Name = "AddConfigButton"
	AddConfigButton.Parent = InputFrame
	AddConfigButton.AnchorPoint = Vector2.new(0, 0.5)
	AddConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AddConfigButton.BackgroundTransparency = 1.000
	AddConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AddConfigButton.BorderSizePixel = 0
	AddConfigButton.Position = UDim2.new(1, 8, 0.5, 0)
	AddConfigButton.Size = UDim2.new(0, 15, 0, 15)
	AddConfigButton.ZIndex = 209
	AddConfigButton.Image = "rbxassetid://10734923868"
	AddConfigButton.ImageTransparency = 0.500

	UICorner_4.CornerRadius = UDim.new(1, 0)
	UICorner_4.Parent = AddConfigButton

	GetConfigButton.Name = "GetConfigButton"
	GetConfigButton.Parent = ConfigWindowFrame
	GetConfigButton.AnchorPoint = Vector2.new(1, 0)
	GetConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GetConfigButton.BackgroundTransparency = 1.000
	GetConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	GetConfigButton.BorderSizePixel = 0
	GetConfigButton.Position = UDim2.new(1, -8, 0, 10)
	GetConfigButton.Size = UDim2.new(0, 15, 0, 15)
	GetConfigButton.ZIndex = 209
	GetConfigButton.Image = "rbxassetid://10723387265"
	GetConfigButton.ImageTransparency = 0.500

	UICorner_5.CornerRadius = UDim.new(1, 0)
	UICorner_5.Parent = GetConfigButton

	SaveConfigButton.Name = "SaveConfigButton"
	SaveConfigButton.Parent = ConfigWindowFrame
	SaveConfigButton.AnchorPoint = Vector2.new(1, 0)
	SaveConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SaveConfigButton.BackgroundTransparency = 1.000
	SaveConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaveConfigButton.BorderSizePixel = 0
	SaveConfigButton.Position = UDim2.new(1, -8, 0, 28)
	SaveConfigButton.Size = UDim2.new(0, 15, 0, 15)
	SaveConfigButton.ZIndex = 209
	SaveConfigButton.Image = "rbxassetid://10734941499"
	SaveConfigButton.ImageTransparency = 0.500

	UICorner_6.CornerRadius = UDim.new(1, 0)
	UICorner_6.Parent = SaveConfigButton

	DeleteButton.Name = "DeleteButton"
	DeleteButton.Parent = ConfigWindowFrame
	DeleteButton.AnchorPoint = Vector2.new(1, 0)
	DeleteButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DeleteButton.BackgroundTransparency = 1.000
	DeleteButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DeleteButton.BorderSizePixel = 0
	DeleteButton.Position = UDim2.new(1, -8, 0, 55)
	DeleteButton.Size = UDim2.new(0, 15, 0, 15)
	DeleteButton.ZIndex = 209
	DeleteButton.Image = "rbxassetid://10747362393"
	DeleteButton.ImageColor3 = Fatality.Colors.Main
	DeleteButton.ImageTransparency = 0.250

	UICorner_7.CornerRadius = UDim.new(1, 0)
	UICorner_7.Parent = DeleteButton

	Button.MouseButton1Click:Connect(function()
		ElementToggle(true);
	end);

	Fatality:CreateHover(DeleteButton,function(bool)
		if bool then
			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0;
			})
		else
			Fatality:CreateAnimation(DeleteButton,0.3,{
				ImageTransparency = 0.35;
			})
		end;
	end);

	Fatality:CreateHover(SaveConfigButton,function(bool)
		if bool then
			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			Fatality:CreateAnimation(SaveConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	Fatality:CreateHover(GetConfigButton,function(bool)
		if bool then
			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			Fatality:CreateAnimation(GetConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	Fatality:CreateHover(AddConfigButton,function(bool)
		if bool then
			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.15;
			})
		else
			Fatality:CreateAnimation(AddConfigButton,0.3,{
				ImageTransparency = 0.500;
			})
		end;
	end);

	game:GetService('UserInputService').InputBegan:Connect(function(Input,Typing)
		if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
			if UIToggle and not Fatality:IsMouseOverFrame(ConfigWindowFrame) then
				ElementToggle(false);
			end;
		end;
	end);

	local new_button = function()
		local db_selected = Instance.new("TextButton")

		db_selected.Name = Fatality:RandomString()
		db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		db_selected.BackgroundTransparency = 1.000
		db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
		db_selected.BorderSizePixel = 0
		db_selected.Size = UDim2.new(1, 0, 0, 10)
		db_selected.ZIndex = 220
		db_selected.FontFace = Fatality.FontSemiBold
		db_selected.TextColor3 = Color3.fromRGB(150, 150, 150)
		db_selected.TextSize = 12.000
		db_selected.TextXAlignment = Enum.TextXAlignment.Left

		return db_selected;
	end;

	local Configs = {};
	local import = {
		Name = nil,
		Element = nil;
	};

	local res;
	res = Fatality:CreateResponse({
		SetFiles = function(configs,bypass)
			local OldLen = #Configs;

			Configs = configs;

			if OldLen ~= #configs and not bypass then
				res:ReloadConfig();
			end;
		end,

		Refresh = function()
			for i,v in next , ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					v:Destroy();
				end;
			end;

			for i,v in next, Configs do
				local button = new_button();

				button.Parent = ScrollingFrame;
				button.Text = " "..tostring(v);

				if tostring(import.Name) == tostring(v) or import.Name == v then
					import.Element = button;
					import.Name = v;
					import.Element.TextColor3 = Fatality.Colors.Main;
					button.Text = "  "..tostring(v);
				end;

				button.MouseButton1Click:Connect(function()
					if import.Element then
						import.Element.TextColor3 = Color3.fromRGB(150, 150, 150);
						import.Element.Text = " "..import.Name;
					end;

					import.Element = button;
					import.Name = v;
					button.TextColor3 = Fatality.Colors.Main;
					button.Text = "  "..tostring(v);
				end);
			end;
		end,

		ReloadConfig = function()
			assert(res.ConfigDirectory , "Config directory not found");

			local files = {};

			for i,v in next , listfiles(res.ConfigDirectory) do
				local spl = (string.find(v,'/',1,true) and string.split(v,'/')) or (string.find(v,'\\',1,true) and string.split(v,'\\'));
				local name = spl[#spl];

				table.insert(files,name);
			end;

			res:SetFiles(files,true);
			res:Refresh();
		end,

		DeleteConfig = function(name)
			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			if isfile(path) then
				delfile(path)
			end;
		end,

		SaveConfig = function(name,content)
			if string.find(name,'/',1,true) or string.find(name,'\\',1,true) or string.find(name,':',1,true) then
				return;	
			end;

			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			writefile(path , content);
		end,

		LoadConfig = function(name)

			assert(res.ConfigDirectory , "Config directory not found");

			local path = res.ConfigDirectory..'/'..tostring(name);

			if isfile(path) then
				local decoded = game:GetService('HttpService'):JSONDecode(readfile(path));

				Fatal.Notifier:Notify({
					Title = "Config",
					Content = "Loaded config '"..tostring(name).."'",
					Icon = "settings",
					Duration = 4,
				});

				Fatal:LoadConfig(decoded);
			end;
		end,

		Init = function(Name: string,Folder: string)
			if not isfolder(Folder or "Fatality") then
				makefolder(Folder or "Fatality");	
			end;

			if not isfolder((Folder or "Fatality").."/Config") then
				makefolder((Folder or "Fatality").."/Config");	
			end;

			local cfgPath = (Folder or "Fatality").."/Config/"..tostring(Name);

			if not isfolder(cfgPath) then
				makefolder(cfgPath)
			end;

			res.ConfigDirectory = cfgPath;

			AddConfigButton.MouseButton1Click:Connect(function()
				local configName = TextBox.Text;

				if not configName:byte() then return end;

				local flags = Fatal:GetFlagConfig();

				flags.Info = {
					Name = Name,
					Folder = Folder,
					ConfigName = configName,
				};

				local code = game:GetService('HttpService'):JSONEncode(flags);

				res:SaveConfig(configName , code);
				res:ReloadConfig();

				Fatal.Notifier:Notify({
					Title = "Config",
					Content = "Saved config '"..tostring(configName).."'",
					Icon = "settings",
					Duration = 4,
				});

				TextBox.Text = "";
			end);

			GetConfigButton.MouseButton1Click:Connect(function()
				if import and import.Name then
					res:LoadConfig(import.Name);
				end;
			end);

			SaveConfigButton.MouseButton1Click:Connect(function()
				if import and import.Name then
					local flags = Fatal:GetFlagConfig();
					local configName = import.Name;

					flags.Info = {
						Name = Name,
						Folder = Folder,
						ConfigName = configName,
						Type = "Overwrite"
					};

					Fatal.Notifier:Notify({
						Title = "Config",
						Content = "Saved config '"..tostring(configName).."'",
						Icon = "settings",
						Duration = 4,
					});

					local code = game:GetService('HttpService'):JSONEncode(flags);

					res:SaveConfig(configName , code);
					res:ReloadConfig();
				end;
			end);

			DeleteButton.MouseButton1Click:Connect(function()
				if import and import.Name then

					Fatal.Notifier:Notify({
						Title = "Config",
						Content = "Deleted config '"..tostring(import.Name).."'",
						Icon = "settings",
						Duration = 4,
					});

					res:DeleteConfig(import.Name);
					res:ReloadConfig();
				end;
			end)
		end,
	});

	return res;
end;

function Fatality.new(Window: Window)
	Window = Window or {};
	Window.Name = Window.Name or "FATALITY";
	Window.Scale = Window.Scale or UDim2.new(0, 750, 0, 500);
	Window.Keybind = Window.Keybind or "Insert";
	Window.Expire = Window.Expire or "never";

	if Window.Watermark == nil then
		Window.Watermark = true;
	end;

	local Fatal = {
		Menus = {},
		ElementContents = {},
		MenuSelected = nil,
		Toggle = true,
		Signal = Instance.new('BindableEvent');
	};

	Fatal.Notifier = Fatality.__NOTIFIER_CACHE or Fatality:CreateNotifier();

	local Fatalitywin = Instance.new("ScreenGui")
	local FatalFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local DropShadow = Instance.new("ImageLabel")
	local Header = Instance.new("Frame")
	local HeaderLine = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local HeaderText = Instance.new("TextLabel")
	local MenuButtonCont = Instance.new("Frame")
	local tbc = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local UserProfle = Instance.new("Frame")
	local UserIcon = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local User_name = Instance.new("TextLabel")
	local expire_days = Instance.new("TextLabel")
	local HeaderLineShadow = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local MenuFrame = Instance.new("Frame")
	local Bottom = Instance.new("Frame")
	local HeaderLine_2 = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local HeaderLineShadow_2 = Instance.new("Frame")
	local UIGradient_2 = Instance.new("UIGradient")
	local UICorner_6 = Instance.new("UICorner")
	local InfoButton = Instance.new("ImageButton")
	local SearchButton = Instance.new("ImageButton")
	local SaveButton = Instance.new("ImageButton")

	Fatality.WindowFlags[Fatalitywin] = {};

	Fatality:ScrollSignal(tbc,UIListLayout,'X');

	FatalFrame:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()
		if FatalFrame.BackgroundTransparency >= 0.99 then
			Fatalitywin.Enabled = false;
		else
			Fatalitywin.Enabled = true;
		end;
	end);

	local ToggleUI = function(bool)
		Fatal.Signal:Fire(bool);

		if bool then
			for i,v in next , Fatal.Menus do
				v.ValueSelect(false);
			end;

			if Fatal.MenuSelected then
				Fatal.MenuSelected.ValueSelect(true)
			end

			Fatality:CreateAnimation(FatalFrame,0.15,{
				Size = Window.Scale,
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(Header,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(HeaderLine,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(Bottom,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(HeaderLine_2,0.5,{
				BackgroundTransparency = 0,
			})

			Fatality:CreateAnimation(HeaderLineShadow,0.5,{
				BackgroundTransparency = 0.5,
			})

			Fatality:CreateAnimation(HeaderLineShadow_2,0.5,{
				BackgroundTransparency = 0.5,
			})

			Fatality:CreateAnimation(InfoButton,0.25,{
				ImageTransparency = 0.5
			})

			Fatality:CreateAnimation(SearchButton,0.25,{
				ImageTransparency = 0.5
			})

			Fatality:CreateAnimation(SaveButton,0.25,{
				ImageTransparency = 0.5
			})

			Fatality:CreateAnimation(HeaderText,0.35,{
				TextStrokeTransparency = 0.640,
				TextTransparency = 0
			})

			Fatality:CreateAnimation(UserIcon,0.45,{
				ImageTransparency = 0,
				Position = UDim2.new(1, -10,0.5, 0)
			})

			Fatality:CreateAnimation(User_name,0.35,{
				TextTransparency = 0,
				Position = UDim2.new(1, -40,0, 3)
			})

			Fatality:CreateAnimation(expire_days,0.5,{
				TextTransparency = 0,
				Position = UDim2.new(1, -40,0, 16)
			})

			Fatality:CreateAnimation(UIStroke,0.35,{
				Thickness = 2.500,
				Transparency = 0.900
			})

			Fatality:CreateAnimation(InfoButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(1, -5,0.5, 0)
			})

			Fatality:CreateAnimation(SearchButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(0,10,0.5, 0)
			})

			Fatality:CreateAnimation(SaveButton,0.1,Enum.EasingStyle.Back,{
				Position = UDim2.new(0,35,0.5, 0)
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 0.75
			})
		else
			table.clear(Fatality.DragBlacklist);

			for i,v in next , Fatal.Menus do
				v.ValueSelect(false);
			end;

			Fatality:CreateAnimation(SaveButton,0.35,{
				Position = UDim2.new(0,35,1, 20)
			})

			Fatality:CreateAnimation(SearchButton,0.35,{
				Position = UDim2.new(0,10,1, 20)
			})

			Fatality:CreateAnimation(InfoButton,0.35,{
				Position = UDim2.new(1, -5,1, 20)
			})

			Fatality:CreateAnimation(UIStroke,0.35,{
				Thickness = 0,
				Transparency = 1
			})

			Fatality:CreateAnimation(UserIcon,0.35,{
				ImageTransparency = 1,
				Position = UDim2.new(1, -10,0.5, 0)
			})

			Fatality:CreateAnimation(User_name,0.35,{
				TextTransparency = 1,
				Position = UDim2.new(1, -40,0, 3)
			})

			Fatality:CreateAnimation(expire_days,0.1,{
				TextTransparency = 1,
				Position = UDim2.new(1, -40,0, 16)
			})

			Fatality:CreateAnimation(HeaderText,0.35,{
				TextStrokeTransparency = 1,
				TextTransparency = 1
			})

			Fatality:CreateAnimation(HeaderLineShadow_2,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(InfoButton,0.35,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(SearchButton,0.35,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(SaveButton,0.35,{
				ImageTransparency = 1
			})

			Fatality:CreateAnimation(HeaderLineShadow,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(FatalFrame,0.75,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(Header,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(HeaderLine,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(Bottom,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(HeaderLine_2,0.5,{
				BackgroundTransparency = 1,
			})

			Fatality:CreateAnimation(DropShadow,0.35,{
				ImageTransparency = 1
			})
		end
	end

	Fatalitywin.Name = Fatality:RandomString();
	Fatalitywin.Parent = CoreGui;
	Fatalitywin.ResetOnSpawn = false;
	Fatalitywin.IgnoreGuiInset = true;
	Fatalitywin.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	table.insert(Fatality.Windows,Fatalitywin)

	protect_gui(Fatalitywin);

	FatalFrame.Active = true;
	FatalFrame.Name = Fatality:RandomString()
	FatalFrame.Parent = Fatalitywin
	FatalFrame.AnchorPoint = Vector2.new(0.5, 0)
	FatalFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
	FatalFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FatalFrame.BorderSizePixel = 0
	FatalFrame.Position = UDim2.new(0.5, 0, 0.2);
	FatalFrame.Size = Window.Scale;
	FatalFrame.ClipsDescendants = true

	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = FatalFrame

	DropShadow.Name = Fatality:RandomString()
	DropShadow.Parent = FatalFrame
	DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow.BackgroundTransparency = 1.000
	DropShadow.BorderSizePixel = 0
	DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	DropShadow.Size = UDim2.new(1, 47, 1, 47)
	DropShadow.ZIndex = -1
	DropShadow.Image = "rbxassetid://6014261993"
	DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	DropShadow.ImageTransparency = 1
	DropShadow.ScaleType = Enum.ScaleType.Slice
	DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
	DropShadow.Rotation = 0.001

	Header.Name = Fatality:RandomString()
	Header.Parent = FatalFrame
	Header.Active = true
	Header.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0, 0, 40)
	Header.ZIndex = 2

	HeaderLine.Name = Fatality:RandomString()
	HeaderLine.Parent = Header
	HeaderLine.AnchorPoint = Vector2.new(0, 1)
	HeaderLine.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	HeaderLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine.BorderSizePixel = 0
	HeaderLine.Position = UDim2.new(0, 0, 1, 0)
	HeaderLine.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine.ZIndex = 3

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = Header

	HeaderText.Name = Fatality:RandomString()
	HeaderText.Parent = Header
	HeaderText.AnchorPoint = Vector2.new(0, 0.5)
	HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderText.BackgroundTransparency = 1.000
	HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderText.BorderSizePixel = 0
	HeaderText.Position = UDim2.new(0, 5, 0.5, 0)
	HeaderText.Size = UDim2.new(0, 100, 0.699999988, 0)
	HeaderText.ZIndex = 4
	HeaderText.Font = Enum.Font.GothamBold
	HeaderText.Text = Window.Name
	HeaderText.TextColor3 = Color3.fromRGB(229, 229, 229)
	HeaderText.TextSize = 21.000
	HeaderText.TextStrokeColor3 = Color3.fromRGB(255, 140, 0)
	HeaderText.TextStrokeTransparency = 0.640

	MenuButtonCont.Name = Fatality:RandomString()
	MenuButtonCont.Parent = Header
	MenuButtonCont.AnchorPoint = Vector2.new(0, 0.5)
	MenuButtonCont.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuButtonCont.BackgroundTransparency = 1.000
	MenuButtonCont.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuButtonCont.BorderSizePixel = 0
	MenuButtonCont.ClipsDescendants = true
	MenuButtonCont.Position = UDim2.new(0, 115, 0.5, 0)
	MenuButtonCont.Size = UDim2.new(1, -275, 0.75, 0)
	MenuButtonCont.ZIndex = 4

	tbc.Name = Fatality:RandomString()
	tbc.Parent = MenuButtonCont
	tbc.Active = true
	tbc.AnchorPoint = Vector2.new(0.5, 0.5)
	tbc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tbc.BackgroundTransparency = 1.000
	tbc.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tbc.BorderSizePixel = 0
	tbc.ClipsDescendants = false
	tbc.Position = UDim2.new(0.5, 0, 0.5, 0)
	tbc.Size = UDim2.new(1, -2, 1, 0)
	tbc.ZIndex = 4
	tbc.CanvasSize = UDim2.new(2, 0, 0, 0)
	tbc.ScrollBarThickness = 0

	UIListLayout.Parent = tbc
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 4)

	UserProfle.Name = Fatality:RandomString()
	UserProfle.Parent = Header
	UserProfle.AnchorPoint = Vector2.new(1, 0.5)
	UserProfle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserProfle.BackgroundTransparency = 1.000
	UserProfle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserProfle.BorderSizePixel = 0
	UserProfle.Position = UDim2.new(1, -5, 0.5, 0)
	UserProfle.Size = UDim2.new(0, 150, 0.75, 0)
	UserProfle.ZIndex = 4

	UserIcon.Name = Fatality:RandomString()
	UserIcon.Parent = UserProfle
	UserIcon.AnchorPoint = Vector2.new(1, 0.5)
	UserIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserIcon.BackgroundTransparency = 1.000
	UserIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserIcon.BorderSizePixel = 0
	UserIcon.Position = UDim2.new(1, -10, 0.5, 0)
	UserIcon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
	UserIcon.SizeConstraint = Enum.SizeConstraint.RelativeYY
	UserIcon.ZIndex = 5
	UserIcon.Image = Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180);

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = UserIcon

	UIStroke.Thickness = 2.500
	UIStroke.Transparency = 0.900
	UIStroke.Parent = UserIcon

	User_name.Name = Fatality:RandomString()
	User_name.Parent = UserProfle
	User_name.AnchorPoint = Vector2.new(1, 0)
	User_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	User_name.BackgroundTransparency = 1.000
	User_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
	User_name.BorderSizePixel = 0
	User_name.Position = UDim2.new(1, -40, 0, 3)
	User_name.Size = UDim2.new(0, 200, 0, 15)
	User_name.ZIndex = 4
	User_name.Font = Enum.Font.GothamMedium
	User_name.Text = Client.DisplayName;
	User_name.TextColor3 = Color3.fromRGB(255, 255, 255)
	User_name.TextSize = 13.000
	User_name.TextStrokeTransparency = 0.700
	User_name.TextXAlignment = Enum.TextXAlignment.Right

	expire_days.Name = Fatality:RandomString()
	expire_days.Parent = UserProfle
	expire_days.AnchorPoint = Vector2.new(1, 0)
	expire_days.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	expire_days.BackgroundTransparency = 1.000
	expire_days.BorderColor3 = Color3.fromRGB(0, 0, 0)
	expire_days.BorderSizePixel = 0
	expire_days.Position = UDim2.new(1, -40, 0, 16)
	expire_days.Size = UDim2.new(0, 200, 0, 15)
	expire_days.ZIndex = 4
	expire_days.Font = Enum.Font.GothamMedium
	expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#ff8c00\">%s</font>",Window.Expire)
	expire_days.TextColor3 = Color3.fromRGB(255, 255, 255)
	expire_days.TextSize = 12.000
	expire_days.TextStrokeTransparency = 0.700
	expire_days.TextXAlignment = Enum.TextXAlignment.Right
	expire_days.RichText = true;

	HeaderLineShadow.Name = Fatality:RandomString()
	HeaderLineShadow.Parent = Header
	HeaderLineShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow.BorderSizePixel = 0
	HeaderLineShadow.Size = UDim2.new(1, 0, 1, 10)

	UIGradient.Rotation = 90
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient.Parent = HeaderLineShadow

	UICorner_4.CornerRadius = UDim.new(0, 5)
	UICorner_4.Parent = HeaderLineShadow

	MenuFrame.Name = Fatality:RandomString()
	MenuFrame.Parent = FatalFrame
	MenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MenuFrame.BackgroundTransparency = 1.000
	MenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MenuFrame.BorderSizePixel = 0
	MenuFrame.Position = UDim2.new(0, 0, 0, 50)
	MenuFrame.Size = UDim2.new(1, 0, 1, -82)

	Bottom.Name = Fatality:RandomString()
	Bottom.Parent = FatalFrame
	Bottom.Active = true
	Bottom.AnchorPoint = Vector2.new(0, 1)
	Bottom.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
	Bottom.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Bottom.BorderSizePixel = 0
	Bottom.Position = UDim2.new(0, 0, 1, 0)
	Bottom.Size = UDim2.new(1, 0, 0, 25)
	Bottom.ZIndex = 2

	HeaderLine_2.Name = Fatality:RandomString()
	HeaderLine_2.Parent = Bottom
	HeaderLine_2.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
	HeaderLine_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLine_2.BorderSizePixel = 0
	HeaderLine_2.Size = UDim2.new(1, 0, 0, 1)
	HeaderLine_2.ZIndex = 3

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = Bottom

	HeaderLineShadow_2.Name = Fatality:RandomString()
	HeaderLineShadow_2.Parent = Bottom
	HeaderLineShadow_2.AnchorPoint = Vector2.new(0, 1)
	HeaderLineShadow_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BackgroundTransparency = 0.500
	HeaderLineShadow_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderLineShadow_2.BorderSizePixel = 0
	HeaderLineShadow_2.Position = UDim2.new(0, 0, 1, 0)
	HeaderLineShadow_2.Size = UDim2.new(1, 0, 1, 5)

	UIGradient_2.Rotation = -90
	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
	UIGradient_2.Parent = HeaderLineShadow_2

	UICorner_6.CornerRadius = UDim.new(0, 5)
	UICorner_6.Parent = HeaderLineShadow_2

	-- Drag: header and bottom bar always drag the window (even over elements), the free area too --
	Fatality:Drag(Header,FatalFrame,0,true);
	Fatality:Drag(Bottom,FatalFrame,0,true);
	Fatality:Drag(FatalFrame,FatalFrame,0,false);

	UserInputService.InputBegan:Connect(function(input,istyping)
		if not istyping then
			if input.KeyCode == Window.Keybind or input.KeyCode.Name == Window.Keybind then
				Fatal.Toggle = not Fatal.Toggle;

				ToggleUI(Fatal.Toggle);
			end;
		end
	end)

	function Fatal:SetUsername(name: string)
		User_name.Text = name or Client.DisplayName;
		Fatal.WatermarkNick = name;
	end;

	function Fatal:SetProfile(icon: string)
		UserIcon.Image = icon or Players:GetUserThumbnailAsync(Client.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size180x180);
	end;

	function Fatal:SetExpire(str: string)
		expire_days.Text = string.format("<font transparency=\"0.5\">expires:</font> <font color=\"#ff8c00\">%s</font>",str)
	end;

	function Fatal:GetFlags()
		return Fatality.WindowFlags[Fatalitywin];
	end;

	function Fatal:AddConfig()
		local ConfigButton = Instance.new("ImageButton")

		ConfigButton.Name = "ConfigButton"
		ConfigButton.Parent = Bottom;
		ConfigButton.AnchorPoint = Vector2.new(0, 0.5)
		ConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ConfigButton.BackgroundTransparency = 1.000
		ConfigButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigButton.BorderSizePixel = 0
		ConfigButton.Position = UDim2.new(0, 57, 0.5, 0)
		ConfigButton.Size = UDim2.new(0, 16, 0, 16)
		ConfigButton.ZIndex = 4
		ConfigButton.Image = "rbxassetid://10723387721"
		ConfigButton.ImageTransparency = 0.500;

		Fatality:CreateHover(ConfigButton,function(bool)
			if bool then
				Fatality:CreateAnimation(ConfigButton,0.3,{
					ImageTransparency = 0.2500;
				})
			else
				Fatality:CreateAnimation(ConfigButton,0.3,{
					ImageTransparency = 0.500;
				})
			end;
		end);

		return Fatality:CreateConfigWindow(Fatalitywin,Fatal,ConfigButton);
	end;

	function Fatal:LoadConfig(config)

		for i,v in next , config do
			if i ~= "Info" then
				local Element = Fatality.WindowFlags[Fatalitywin][i];

				if Element then

					local Value = v.Value;
					local MainValue;

					task.spawn(function()
						if Value.Type == "String" then
							Element:SetValue(tostring(Value.Value));
						elseif Value.Type == "Boolean" then
							Element:SetValue((typeof(Value.Value) == 'boolean' and Value.Value) or (Value.Value == "true" and true or false));
						elseif Value.Type == "Number" then
							Element:SetValue(Value.Value);
						elseif Value.Type == "Color3" then
							Element:SetValue(Color3.new(Value.Value.R,Value.Value.G,Value.Value.B) , Value.Value.Transparency);
						elseif Value.Type == "Table" then
							Element:SetValue(Value.Value);

						end;
					end);
				end;

			end;
		end;
	end;

	function Fatal:GetFlagConfig()
		local Flags = Fatal:GetFlags();

		local ConfigElement = {};

		for i,v in next , Flags do
			local ValueData = {};
			local Value = v:GetValue();

			if typeof(Value) == "string" then
				ValueData.Type = "String";
				ValueData.Value = Value;
			elseif typeof(Value) == "boolean" then
				ValueData.Type = "Boolean";
				ValueData.Value = Value;
			elseif typeof(Value) == "number" then
				ValueData.Type = "Number";
				ValueData.Value = Value;
			elseif typeof(Value) == "Color3" then
				ValueData.Type = "Color3";

				local Color = Value.Color;
				local Transparency = Value.Transparency;

				ValueData.Value = {
					R = Color.R,
					G = Color.G,
					B = Color.B,

					Transparency = Transparency
				};
			elseif typeof(Value) == "EnumItem" then
				ValueData.Type = "String";
				ValueData.Value = Value.Name;
			elseif typeof(Value) == "table" then
				if Value.Color and Value.Transparency then
					ValueData.Type = "Color3";

					local Color = Value.Color;
					local Transparency = Value.Transparency;

					ValueData.Value = {
						R = Color.R,
						G = Color.G,
						B = Color.B,

						Transparency = Transparency
					};
				else
					ValueData.Type = "Table";
					ValueData.Value = Value;
				end;
			else
				ValueData.Type = "Unknow";
				ValueData.Value = nil;
			end;

			rawset(ConfigElement,i,{
				FlagId = v.Flag,
				Value = ValueData,
			})
		end;

		return ConfigElement;
	end;

	function Fatal:AddMenu(Menu : Menu)
		Menu = Menu or {};
		Menu.Name = Menu.Name or "EXAMPLE";
		Menu.Icon = Menu.Icon or "eye";
		Menu.AutoFill = (Menu.AutoFill == nil and true) or false;

		local MenuLib = {};
		local MenuButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local Icon = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local menu_name = Instance.new("TextLabel")

		MenuButton.Name = Fatality:RandomString()
		MenuButton.Parent = tbc;
		MenuButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		MenuButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuButton.BorderSizePixel = 0
		MenuButton.Size = UDim2.new(0, 90, 0.85, 0)
		MenuButton.ZIndex = 5
		MenuButton.LayoutOrder = Menu.LayoutOrder or 0;

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = MenuButton

		UIStroke.Transparency = 0.950
		UIStroke.Parent = MenuButton

		Icon.Name = Fatality:RandomString()
		Icon.Parent = MenuButton
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 5, 0.5, 0)
		Icon.Size = UDim2.new(0.800000012, 0, 0.800000012, 0)
		Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Icon.ZIndex = 5
		Icon.Image = Fatality:GetIcon(Menu.Icon);
		Icon.ImageColor3 = Fatality.Colors.Main
		Icon.ScaleType = Enum.ScaleType.Crop

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Icon

		menu_name.Name = Fatality:RandomString()
		menu_name.Parent = MenuButton
		menu_name.AnchorPoint = Vector2.new(0, 0.5)
		menu_name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		menu_name.BackgroundTransparency = 1.000
		menu_name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		menu_name.BorderSizePixel = 0
		menu_name.Position = UDim2.new(0, 28, 0.5, 0)
		menu_name.Size = UDim2.new(1, 0, 1, 0)
		menu_name.ZIndex = 5
		menu_name.Font = Enum.Font.GothamBold
		menu_name.Text = Menu.Name
		menu_name.TextColor3 = Color3.fromRGB(255, 255, 255)
		menu_name.TextSize = 13.000
		menu_name.TextStrokeTransparency = 0.900
		menu_name.TextTransparency = 0.150
		menu_name.TextXAlignment = Enum.TextXAlignment.Left

		local text_size = Fatality:GetTextSize(menu_name);

		MenuButton.Size = UDim2.new(0, text_size.X + 33, 0.85, 0)

		local MenuLiber = Instance.new("Frame")
		local Left = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local Center = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local Right = Instance.new("ScrollingFrame")
		local UIListLayout_3 = Instance.new("UIListLayout")

		MenuLiber.Name = Fatality:RandomString()
		MenuLiber.Parent = MenuFrame
		MenuLiber.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MenuLiber.BackgroundTransparency = 1.000
		MenuLiber.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MenuLiber.BorderSizePixel = 0
		MenuLiber.ClipsDescendants = true
		MenuLiber.Size = UDim2.new(1, 0, 1, 0)
		MenuLiber.ZIndex = 7

		Left.Name = Fatality:RandomString()
		Left.Parent = MenuLiber
		Left.Active = true
		Left.AnchorPoint = Vector2.new(0.5, 0.5)
		Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Left.BackgroundTransparency = 1.000
		Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Left.BorderSizePixel = 0
		Left.ClipsDescendants = false
		Left.Position = UDim2.new(0.175, 0, 0.5, 0)
		Left.Size = UDim2.new(0.32, 0, 1, -5)
		Left.ScrollBarThickness = 0

		UIListLayout.Parent = Left
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		Center.Name = Fatality:RandomString()
		Center.Parent = MenuLiber
		Center.Active = true
		Center.AnchorPoint = Vector2.new(0.5, 0.5)
		Center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Center.BackgroundTransparency = 1.000
		Center.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Center.BorderSizePixel = 0
		Center.ClipsDescendants = false
		Center.Position = UDim2.new(0.5, 0, 0.5, 0)
		Center.Size = UDim2.new(0.32, 0, 1, -5)
		Center.ScrollBarThickness = 0

		UIListLayout_2.Parent = Center
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)
		UIListLayout_2.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		Right.Name = Fatality:RandomString()
		Right.Parent = MenuLiber
		Right.Active = true
		Right.AnchorPoint = Vector2.new(0.5, 0.5)
		Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Right.BackgroundTransparency = 1.000
		Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Right.BorderSizePixel = 0
		Right.ClipsDescendants = false
		Right.Position = UDim2.new(0.825, 0, 0.5, 0)
		Right.Size = UDim2.new(0.32, 0, 1, -5)
		Right.ScrollBarThickness = 0

		UIListLayout_3.Parent = Right
		UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.Padding = UDim.new(0, 5)
		UIListLayout_3.VerticalFlex = (Menu.AutoFill and Enum.UIFlexAlignment.Fill) or Enum.UIFlexAlignment.None;

		local BindEvent = Instance.new('BindableEvent',MenuLiber);
		BindEvent.Name = Fatality:RandomString();

		if not Menu.AutoFill then
			Fatality:ScrollSignal(Right,UIListLayout_3,'Y');
			Fatality:ScrollSignal(Center,UIListLayout_2,'Y');
			Fatality:ScrollSignal(Left,UIListLayout,'Y');
		else
			Right.CanvasSize = UDim2.new(0,0,0,0);
			Left.CanvasSize = UDim2.new(0,0,0,0);
			Center.CanvasSize = UDim2.new(0,0,0,0);
		end;

		Fatal.Signal.Event:Connect(function(Bool)
			if Bool then
				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = (MenuLiber.Visible and 0) or 1
				})

				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 0.950
				})

				Fatality:CreateAnimation(Left,0.3,{
					Position = UDim2.new(0.175, 0, 0.5, 0)
				})

				Fatality:CreateAnimation(Center,0.4,{
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})

				Fatality:CreateAnimation(Right,0.5,{
					Position = UDim2.new(0.825, 0, 0.5, 0)
				})

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = (MenuLiber.Visible and 0.15) or 0.5
				})

				Fatality:CreateAnimation(menu_name,0.5,{
					TextStrokeTransparency = 0.900,
					TextTransparency = (MenuLiber.Visible and 0.15) or 0.5
				})
			else
				Fatality:CreateAnimation(Left,0.5,{
					Position = UDim2.new(0.175, 0, 0.5, 1)
				})

				Fatality:CreateAnimation(Center,0.5,{
					Position = UDim2.new(0.5, 0, 0.5, 2)
				})

				Fatality:CreateAnimation(Right,0.5,{
					Position = UDim2.new(0.825, 0, 0.5, 3)
				})

				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 1
				})

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(menu_name,0.5,{
					TextStrokeTransparency = 1,
					TextTransparency = 1
				})
			end;
		end)

		local ValueSelect = function(val)
			if val then
				MenuLiber.Visible = true;

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = 0.15,
					ImageColor3 = Fatality.Colors.Main
				});

				Fatality:CreateAnimation(menu_name,0.5,{
					TextTransparency = 0.15
				});

				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 0
				})

				BindEvent:SetAttribute('V',true);
				BindEvent:Fire(true);
			else
				BindEvent:SetAttribute('V',false);
				BindEvent:Fire(false);

				MenuLiber.Visible = false;

				Fatality:CreateAnimation(Icon,0.5,{
					ImageTransparency = 0.5,
					ImageColor3 = Color3.fromRGB(255, 255, 255)
				});

				Fatality:CreateAnimation(MenuButton,0.5,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(menu_name,0.5,{
					TextTransparency = 0.5
				});
			end;
		end;

		local _B = {
			Root = MenuLiber,
			ValueSelect = ValueSelect,
			Bindable = BindEvent,
		};

		if not Fatal.MenuSelected and not Menu.NoSelect then
			Fatal.MenuSelected = _B;

			ValueSelect(true);
		else
			ValueSelect(false);
		end;

		table.insert(Fatal.Menus,_B)

		Fatality:CreateHover(MenuButton,function(bool)
			if not Fatal.MenuSelected or Fatal.MenuSelected.Root ~= MenuLiber then
				if bool then
					Fatality:CreateAnimation(Icon,0.5,{
						ImageTransparency = 0.2,
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					});

					Fatality:CreateAnimation(MenuButton,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(menu_name,0.5,{
						TextTransparency = 0.2
					});
				else
					Fatality:CreateAnimation(Icon,0.5,{
						ImageTransparency = 0.5,
						ImageColor3 = Color3.fromRGB(255, 255, 255)
					});

					Fatality:CreateAnimation(MenuButton,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(menu_name,0.5,{
						TextTransparency = 0.5
					});
				end
			end;
		end)

		Fatality:NewInput(MenuButton,function()
			for i,v in next , Fatal.Menus do
				if v.Root == MenuLiber then
					Fatal.MenuSelected = v;

					v.ValueSelect(true)
				else
					v.ValueSelect(false)
				end;
			end;
		end);
		
		function MenuLib:AddPreview(Config: Preview)
			Config = Config or {};
			Config.Name = Config.Name or "PREVIEW";
			Config.Position = Config.Position or "left";
			Config.Height = Config.Height or 0;
			
			local Preview = Instance.new("Frame")
			local PreviewName = Instance.new("TextLabel")
			local Main = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local MainBlock = Instance.new("Frame")

			Preview.Name = "Preview"
			Preview.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Preview.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			Preview.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Preview.BorderSizePixel = 0
			Preview.ClipsDescendants = true
			Preview.ZIndex = 15;
			Preview.Size = UDim2.new(1, 0, 0, 25 + Config.Height)
	
			PreviewName.Name = "PreviewName"
			PreviewName.Parent = Preview
			PreviewName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PreviewName.BackgroundTransparency = 1.000
			PreviewName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PreviewName.BorderSizePixel = 0
			PreviewName.Position = UDim2.new(0, 10, 0, 0)
			PreviewName.Size = UDim2.new(1, 0, 0, 15)
			PreviewName.ZIndex = 19
			PreviewName.FontFace = Fatality.FontSemiBold
			PreviewName.Text = Config.Name
			PreviewName.TextColor3 = Color3.fromRGB(255, 255, 255)
			PreviewName.TextSize = 15.000
			PreviewName.TextStrokeTransparency = 0.750
			PreviewName.TextXAlignment = Enum.TextXAlignment.Left

			Main.Name = "Main"
			Main.Parent = Preview
			Main.AnchorPoint = Vector2.new(0.5, 1)
			Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Main.BorderSizePixel = 0
			Main.Position = UDim2.new(0.5, 0, 1, -1)
			Main.Size = UDim2.new(1, -5, 1, -10)
			Main.ZIndex = 17

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Main

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Main

			MainBlock.Name = "MainBlock"
			MainBlock.Parent = Main
			MainBlock.AnchorPoint = Vector2.new(0.5, 0.5)
			MainBlock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MainBlock.BackgroundTransparency = 1.000
			MainBlock.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MainBlock.BorderSizePixel = 0
			MainBlock.Position = UDim2.new(0.5, 0, 0.5, 0)
			MainBlock.Size = UDim2.new(1, -5, 1, -5)
			MainBlock.ZIndex = 18
			
			local Toggle = function(v)
				if v then
					Fatality:CreateAnimation(Preview,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(PreviewName,0.5,{
						TextStrokeTransparency = 0.750,
						TextTransparency = 0
					})
					
					Fatality:CreateAnimation(Main,0.5,{
						BackgroundTransparency = 0
					})
					
					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})
					
					Fatality:CreateAnimation(MainBlock,0.5,{
						Size = UDim2.new(1, -5, 1, -5)
					})
				else
					Fatality:CreateAnimation(Preview,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(PreviewName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})

					Fatality:CreateAnimation(Main,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(MainBlock,0.5,{
						Size = UDim2.new(0,0,0,0)
					})
				end
			end;

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);
			
			return MainBlock;
		end;

		function MenuLib:AddListBox(Config : Listbox)
			Config = Config or {};
			Config.Name = Config.Name or "LIST BOX";
			Config.Position = Config.Position or "left";
			Config.Height = Config.Height or 0;
			Config.Values = Config.Values or {};
			Config.Multi = Config.Multi or false;
			Config.Default = Config.Default or ((Config.Multi and nil) or {});
			Config.Callback = Config.Callback or function() end;

			table.insert(Fatal.ElementContents,{
				Name = Config.Name,
				Path = Menu.Name .. " > ".. Config.Name,
				_TAB = _B
			});

			local ListBox = Instance.new("Frame")
			local Elements = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local SearchBox = Instance.new("Frame")
			local TextBox = Instance.new("TextBox")
			local UICorner_2 = Instance.new("UICorner")
			local UIStroke_2 = Instance.new("UIStroke")
			local OptionButton = Instance.new("ImageButton")
			local ScrollingFrame = Instance.new("ScrollingFrame")
			local UICorner_3 = Instance.new("UICorner")
			local UIStroke_3 = Instance.new("UIStroke")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local ListName = Instance.new("TextLabel")

			ListBox.Name = Fatality:RandomString()
			ListBox.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			ListBox.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			ListBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListBox.BorderSizePixel = 0
			ListBox.ClipsDescendants = true
			ListBox.Size = UDim2.new(1, 0, 0, 350)
			ListBox.ZIndex = 10
			ListBox.ClipsDescendants = true;

			Fatality:AddDragBlacklist(ScrollingFrame);

			Elements.Name = Fatality:RandomString()
			Elements.Parent = ListBox
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Elements.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)
			Elements.ZIndex = 10

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Elements

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements

			SearchBox.Name = Fatality:RandomString()
			SearchBox.Parent = Elements
			SearchBox.BackgroundColor3 = Fatality.Colors.Black
			SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SearchBox.BorderSizePixel = 0
			SearchBox.ClipsDescendants = true
			SearchBox.Position = UDim2.new(0, 10, 0, 15)
			SearchBox.Size = UDim2.new(0, 195, 0, 16)
			SearchBox.ZIndex = 10

			TextBox.Parent = SearchBox
			TextBox.BackgroundColor3 = Fatality.Colors.Black
			TextBox.BackgroundTransparency = 1.000
			TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextBox.BorderSizePixel = 0
			TextBox.Position = UDim2.new(0, 5, 0, 0)
			TextBox.Size = UDim2.new(1, -10, 0, 16)
			TextBox.ZIndex = 11
			TextBox.ClearTextOnFocus = false
			TextBox.FontFace = Fatality.FontSemiBold
			TextBox.PlaceholderText = "Start typing..."
			TextBox.Text = ""
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 11.000
			TextBox.TextXAlignment = Enum.TextXAlignment.Left

			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = SearchBox

			UIStroke_2.Transparency = 0.750
			UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
			UIStroke_2.Parent = SearchBox

			OptionButton.Name = Fatality:RandomString()
			OptionButton.Parent = Elements
			OptionButton.AnchorPoint = Vector2.new(1, 0)
			OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OptionButton.BackgroundTransparency = 1.000
			OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OptionButton.BorderSizePixel = 0
			OptionButton.Position = UDim2.new(1, -10, 0, 16)
			OptionButton.Size = UDim2.new(0, 13, 0, 13)
			OptionButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
			OptionButton.ZIndex = 11
			OptionButton.Image = "http://www.roblox.com/asset/?id=14007344336"
			OptionButton.ImageTransparency = 0.600
			OptionButton.Visible = Config.Option or false;

			ScrollingFrame.Parent = Elements
			ScrollingFrame.Active = true
			ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
			ScrollingFrame.BackgroundColor3 = Fatality.Colors.Black
			ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
			ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
			ScrollingFrame.ZIndex = 11
			ScrollingFrame.ScrollBarThickness = 0

			UICorner_3.CornerRadius = UDim.new(0, 3)
			UICorner_3.Parent = ScrollingFrame

			UIStroke_3.Transparency = 0.750
			UIStroke_3.Color = Color3.fromRGB(29, 29, 29)
			UIStroke_3.Parent = ScrollingFrame

			UIListLayout.Parent = ScrollingFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local all = (#ScrollingFrame:GetChildren() - 1);
				local scale = math.clamp((all * (10 + UIListLayout.Padding.Offset)) + (Config.Height + UIListLayout.Padding.Offset),25,400);

				if Menu.AutoFill then
					ListBox.Size = UDim2.new(1,0,0,scale / 2.5);
				else
					ListBox.Size = UDim2.new(1,0,0,scale);
				end;

				ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y);
			end)

			SpaceBox.Name = Fatality:RandomString()
			SpaceBox.Parent = ScrollingFrame
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 1)

			ListName.Name = Fatality:RandomString()
			ListName.Parent = ListBox
			ListName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ListName.BackgroundTransparency = 1.000
			ListName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ListName.BorderSizePixel = 0
			ListName.Position = UDim2.new(0, 10, 0, 0)
			ListName.Size = UDim2.new(1, 0, 0, 15)
			ListName.ZIndex = 10
			ListName.FontFace = Fatality.FontSemiBold
			ListName.Text = Config.Name
			ListName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ListName.TextSize = 15.000
			ListName.TextStrokeTransparency = 0.750
			ListName.TextXAlignment = Enum.TextXAlignment.Left

			local new_button = function()
				local db_selected = Instance.new("TextButton")

				db_selected.Name = Fatality:RandomString()
				db_selected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				db_selected.BackgroundTransparency = 1.000
				db_selected.BorderColor3 = Color3.fromRGB(0, 0, 0)
				db_selected.BorderSizePixel = 0
				db_selected.Size = UDim2.new(1, 0, 0, 10)
				db_selected.ZIndex = 15
				db_selected.FontFace = Fatality.FontSemiBold
				db_selected.TextColor3 = Fatality.Colors.Main
				db_selected.TextSize = 12.000
				db_selected.TextTransparency = 0.5;
				db_selected.TextXAlignment = Enum.TextXAlignment.Left

				return db_selected;
			end;

			local Toggle = function(v)
				if v then
					Fatality:CreateAnimation(ListBox,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})

					Fatality:CreateAnimation(UIStroke_2,0.5,{
						Transparency = 0.75
					})

					Fatality:CreateAnimation(UIStroke_3,0.5,{
						Transparency = 0.75
					})

					Fatality:CreateAnimation(SearchBox,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(TextBox,0.5,{
						TextTransparency = 0
					})

					Fatality:CreateAnimation(OptionButton,0.45,{
						ImageTransparency = (Config.Option and 0.6) or 1,
					})

					Fatality:CreateAnimation(ScrollingFrame,0.45,{
						BackgroundTransparency = 0,
						Position = UDim2.new(0.5, 0, 0, 40)
					})

					table.foreach(ScrollingFrame:GetChildren(),function(i,v)
						if v:IsA('TextButton') then
							Fatality:CreateAnimation(v,0.45,{
								TextTransparency = 0.5
							});
						end;
					end);

					Fatality:CreateAnimation(ListName,0.5,{
						TextStrokeTransparency = 0.75,
						TextTransparency = 0
					})
				else

					table.foreach(ScrollingFrame:GetChildren(),function(i,v)
						if v:IsA('TextButton') then
							Fatality:CreateAnimation(v,0.45,{
								TextTransparency = 1
							});
						end;
					end);

					Fatality:CreateAnimation(ListBox,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(UIStroke_2,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(UIStroke_3,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(SearchBox,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(TextBox,0.5,{
						TextTransparency = 1
					})

					Fatality:CreateAnimation(OptionButton,0.45,{
						ImageTransparency = 1
					})

					Fatality:CreateAnimation(ScrollingFrame,0.45,{
						BackgroundTransparency = 1,
						Position = UDim2.new(0.5, 0, 0, 40)
					})

					Fatality:CreateAnimation(ListName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})
				end
			end;

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);

			local DearchDelay = tick();

			TextBox:GetPropertyChangedSignal('Text'):Connect(function()
				DearchDelay = tick();

				if not TextBox.Text:byte() then
					for i,v in next , ScrollingFrame:GetChildren() do
						if v:IsA('TextButton') then
							v.Visible = true;
						end;
					end;

					return;
				end;

				task.delay(0.25,function()
					if (tick() - DearchDelay) > 0.25 then
						for i,v in next , ScrollingFrame:GetChildren() do
							if v:IsA('TextButton') then
								if string.find(string.lower(v.Text),string.lower(TextBox.Text),1,true) then
									v.Visible = true;
								else
									v.Visible = false;
								end;
							end;
						end;
					end;
				end)
			end);

			local res;
			res = Fatality:CreateResponse({
				Refresh = function()
					for i,v in next , ScrollingFrame:GetChildren() do
						if v:IsA('TextButton') then
							v:Destroy();
						end;
					end;

					local selectedmem;

					for i,v in next , Config.Values do
						local bth = new_button();

						bth.Text = string.rep(" ",2)..tostring(v);

						bth.Parent = ScrollingFrame;

						if Config.Multi then
							if (typeof(Config.Default) == 'table' and (Config.Default[v] or table.find(Config.Default,v))) or Config.Default == v then
								Config.Default[v] = true
								bth.TextColor3 = Fatality.Colors.Main;
								bth.TextTransparency = 0;

							else
								bth.TextColor3 = Color3.fromRGB(255, 255, 255);
								bth.TextTransparency = 0.5;

								Config.Default[v] = false
							end;

							Fatality:CreateHover(bth,function(bool)
								if not Config.Default[v] then
									if bool then
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0;
										})
									else
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0.5;
										})
									end;
								end;
							end)

							bth.MouseButton1Click:Connect(function()
								Config.Default[v] = not Config.Default[v];

								if Config.Default[v] then
									bth.TextColor3 = Fatality.Colors.Main;
									bth.TextTransparency = 0;

								else
									bth.TextColor3 = Color3.fromRGB(255, 255, 255);
									bth.TextTransparency = 0.5;
								end;

								Config.Callback(Config.Default);
							end)
						else
							if v == Config.Default then
								selectedmem = bth;
								Config.Default = v;

								bth.TextColor3 = Fatality.Colors.Main;
								bth.TextTransparency = 0;

							else
								bth.TextColor3 = Color3.fromRGB(255, 255, 255);
								bth.TextTransparency = 0.5;
							end;

							Fatality:CreateHover(bth,function(bool)
								if Config.Default ~= v then
									if bool then
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0;
										})
									else
										Fatality:CreateAnimation(bth,0.25,{
											TextTransparency = 0.5;
										})
									end;
								end;
							end)

							bth.MouseButton1Click:Connect(function()
								if selectedmem then
									selectedmem.TextColor3 = Color3.fromRGB(255, 255, 255);
									selectedmem.TextTransparency = 0.5;
								end;

								bth.TextTransparency = 0;
								bth.TextColor3 = Fatality.Colors.Main;
								selectedmem = bth;
								Config.Default = v;

								Config.Callback(v);
							end)
						end;
					end;

					Config.Callback(Config.Default);
				end,
				SetValues = function(value)
					Config.Values = value;

				end,
				SetDefault = function(value)
					Config.Default = value;
				end,
				GetValue = function()
					return Config.Default;
				end,
				Flag = Config.Flag and Config.Flag.."ListBox",
				SetValue = function(a)

					Config.Default = a;

					res:Refresh();

					Config.Callback(Config.Default);
				end,

				Option = (Config.Option and Fatality:CreateOption(OptionButton)) or nil;
			});

			res:Refresh();

			if Config.Flag then
				Fatality.WindowFlags[Fatalitywin][Config.Flag.."ListBox"] = res;
			end;

			return res;
		end;

		function MenuLib:AddSection(Config : Section)
			Config = Config or {};
			Config.Name = Config.Name or "SECTION";
			Config.Position = Config.Position or "center";
			Config.Height = Config.Height or 0;

			table.insert(Fatal.ElementContents,{
				Name = Config.Name,
				Path = Menu.Name .. " > ".. Config.Name,
				_TAB = _B
			});

			local Section = Instance.new("Frame")
			local Elements = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")
			local SpaceBox = Instance.new("Frame")
			local SectionName = Instance.new("TextLabel")

			local Toggle = function(v)
				if v then
					Fatality:CreateAnimation(Section,0.5,{
						BackgroundTransparency = 0
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 0
					})

					Fatality:CreateAnimation(SectionName,0.5,{
						TextStrokeTransparency = 0.750,
						TextTransparency = 0
					})
				else
					Fatality:CreateAnimation(Section,0.5,{
						BackgroundTransparency = 1
					})

					Fatality:CreateAnimation(UIStroke,0.5,{
						Transparency = 1
					})

					Fatality:CreateAnimation(SectionName,0.5,{
						TextStrokeTransparency = 1,
						TextTransparency = 1
					})
				end
			end;

			Section.Name = Fatality:RandomString()
			Section.Parent = (string.lower(Config.Position) == 'left' and Left) or (string.lower(Config.Position) == 'center' and Center) or Right;
			Section.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, 0)

			Elements.Name = Fatality:RandomString()
			Elements.Parent = Section
			Elements.AnchorPoint = Vector2.new(0.5, 1)
			Elements.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			Elements.BackgroundTransparency = 0
			Elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Elements.BorderSizePixel = 0
			Elements.Position = UDim2.new(0.5, 0, 1, -1)
			Elements.Size = UDim2.new(1, -5, 1, -10)

			UIStroke.Color = Color3.fromRGB(29, 29, 29)
			UIStroke.Parent = Elements

			UICorner.CornerRadius = UDim.new(0, 2)
			UICorner.Parent = Elements

			UIListLayout.Parent = Elements
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			SpaceBox.Name = Fatality:RandomString()
			SpaceBox.Parent = Elements
			SpaceBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SpaceBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SpaceBox.BorderSizePixel = 0
			SpaceBox.Size = UDim2.new(0, 0, 0, 10)

			SectionName.Name = Fatality:RandomString()
			SectionName.Parent = Section
			SectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.BackgroundTransparency = 1.000
			SectionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionName.BorderSizePixel = 0
			SectionName.Position = UDim2.new(0, 10, 0, 0)
			SectionName.Size = UDim2.new(1, 0, 0, 15)
			SectionName.FontFace = Fatality.FontSemiBold;
			SectionName.Text = Config.Name
			SectionName.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionName.TextSize = 15.000
			SectionName.TextStrokeTransparency = 0.750
			SectionName.TextXAlignment = Enum.TextXAlignment.Left


			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				local MainScale = UIListLayout.AbsoluteContentSize.Y + 20 + Config.Height;

				if not Menu.AutoFill then
					Fatality:CreateAnimation(Section,0.25,{
						Size = UDim2.new(1, 0, 0, MainScale)
					})
				else
					Section.Size = UDim2.new(1,0,0,MainScale / 2.5);
				end;
			end);

			Toggle(BindEvent:GetAttribute('V'));

			BindEvent.Event:Connect(Toggle);

			return Fatality:CreateElements(Elements,Elements.ZIndex,BindEvent,{
				Path = Menu.Name .. " > ".. Config.Name,
				Memory = function(Name)
					table.insert(Fatal.ElementContents,{
						Name = Name,
						Path = Menu.Name .. " > ".. Config.Name .. " > " .. Name,
						_TAB = _B
					});
				end,
			});
		end;

		return MenuLib;
	end;

	do
		InfoButton.Name = Fatality:RandomString()
		InfoButton.Parent = Bottom
		InfoButton.AnchorPoint = Vector2.new(1, 0.5)
		InfoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		InfoButton.BackgroundTransparency = 1.000
		InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InfoButton.BorderSizePixel = 0
		InfoButton.Position = UDim2.new(1, -5, 0.5, 0)
		InfoButton.Size = UDim2.new(0, 16, 0, 16)
		InfoButton.ZIndex = 4
		InfoButton.Image = "rbxassetid://10723415903"
		InfoButton.ImageTransparency = 0.500

		SearchButton.Name = Fatality:RandomString()
		SearchButton.Parent = Bottom
		SearchButton.AnchorPoint = Vector2.new(0, 0.5)
		SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SearchButton.BackgroundTransparency = 1.000
		SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchButton.BorderSizePixel = 0
		SearchButton.Position = UDim2.new(0, 10, 0.5, 0)
		SearchButton.Size = UDim2.new(0, 16, 0, 16)
		SearchButton.ZIndex = 4
		SearchButton.Image = "rbxassetid://10734943674"
		SearchButton.ImageTransparency = 0.500

		SaveButton.Name = Fatality:RandomString()
		SaveButton.Parent = Bottom
		SaveButton.AnchorPoint = Vector2.new(0, 0.5)
		SaveButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SaveButton.BackgroundTransparency = 1.000
		SaveButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SaveButton.BorderSizePixel = 0
		SaveButton.Position = UDim2.new(0, 35, 0.5, 0)
		SaveButton.Size = UDim2.new(0, 16, 0, 16)
		SaveButton.ZIndex = 4
		SaveButton.Image = "rbxassetid://10734941499"
		SaveButton.ImageTransparency = 0.500

		Fatality:CreateHover(SaveButton,function(bool)
			if bool then
				Fatality:CreateAnimation(SaveButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				Fatality:CreateAnimation(SaveButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		Fatality:CreateHover(InfoButton,function(bool)
			if bool then
				Fatality:CreateAnimation(InfoButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				Fatality:CreateAnimation(InfoButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		function Fatal:AddSave(callback)
			SaveButton.MouseButton1Click:Connect(callback);
		end;

		function Fatal:AddInfo(callback)
			InfoButton.MouseButton1Click:Connect(callback);
		end;
	end;

	do
		local SearchFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local DropShadow = Instance.new("ImageLabel")
		local SearchBox = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local searchScale = UDim2.new(0, 295, 0, 295);

		Fatality:AddDragBlacklist(SearchFrame);

		local SearchToggle = function(value)
			if value then
				SearchFrame.Position = UDim2.fromOffset(SearchButton.AbsolutePosition.X - 5,SearchButton.AbsolutePosition.Y + (SearchButton.AbsoluteSize.Y * 3))

				Fatality:CreateAnimation(SearchFrame,0.35,{
					Size = searchScale
				})

				Fatality:CreateAnimation(DropShadow,0.35,{
					ImageTransparency = 0.750
				})

				Fatality:CreateAnimation(SearchBox,0.35,{
					BackgroundTransparency = 0
				})

				Fatality:CreateAnimation(UIStroke_2,0.5,{
					Transparency = 0.650
				})

				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 0
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 0
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 0
				})
			else
				Fatality:CreateAnimation(UIStroke,0.5,{
					Transparency = 1
				})

				Fatality:CreateAnimation(SearchFrame,0.35,{
					Size = UDim2.new(searchScale.X.Scale, searchScale.X.Offset, 0, 0)
				})

				Fatality:CreateAnimation(DropShadow,0.35,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(SearchBox,0.5,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(UIStroke_2,0.5,{
					Transparency = 1
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(TextBox,0.5,{
					TextTransparency = 1
				})

				table.foreach(ScrollingFrame:GetChildren(),function(i,v)
					if v:IsA('Frame') then
						v:Destroy();
					end;
				end);
			end;
		end;

		SearchFrame.Name = Fatality:RandomString()
		SearchFrame.Parent = Fatalitywin;
		SearchFrame.AnchorPoint = Vector2.new(0, 1)
		SearchFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
		SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchFrame.BorderSizePixel = 0
		SearchFrame.Position = UDim2.new(4,0,4,0)
		SearchFrame.Size = searchScale
		SearchFrame.ZIndex = 100
		SearchFrame.ClipsDescendants = true

		UIStroke.Color = Color3.fromRGB(29, 29, 29)
		UIStroke.Parent = SearchFrame

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = SearchFrame

		DropShadow.Name = Fatality:RandomString()
		DropShadow.Parent = SearchFrame
		DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
		DropShadow.BackgroundTransparency = 1.000
		DropShadow.BorderSizePixel = 0
		DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
		DropShadow.Rotation = 0.010
		DropShadow.Size = UDim2.new(1, 47, 1, 47)
		DropShadow.ZIndex = 99
		DropShadow.Image = "rbxassetid://6014261993"
		DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		DropShadow.ImageTransparency = 0.750
		DropShadow.ScaleType = Enum.ScaleType.Slice
		DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

		SearchBox.Name = Fatality:RandomString()
		SearchBox.Parent = SearchFrame
		SearchBox.AnchorPoint = Vector2.new(0.5, 0)
		SearchBox.BackgroundColor3 = Fatality.Colors.Black
		SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchBox.BorderSizePixel = 0
		SearchBox.Position = UDim2.new(0.5, 0, 0, 9)
		SearchBox.Size = UDim2.new(1, -15, 0, 25)
		SearchBox.ZIndex = 101

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = SearchBox

		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(29, 29, 29)
		UIStroke_2.Parent = SearchBox

		TextBox.Parent = SearchBox
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -15, 1, -5)
		TextBox.ZIndex = 102
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = Fatality.FontSemiBold;
		TextBox.PlaceholderText = "Search"
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 12.000
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		ScrollingFrame.Parent = SearchFrame
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 40)
		ScrollingFrame.Size = UDim2.new(1, -15, 1, -45)
		ScrollingFrame.ZIndex = 102
		ScrollingFrame.ScrollBarThickness = 0

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
		end)

		SearchToggle(false);

		Fatality:CreateHover(SearchButton,function(bool)
			if bool then
				Fatality:CreateAnimation(SearchButton,0.5,{
					ImageTransparency = 0.1
				})
			else
				Fatality:CreateAnimation(SearchButton,0.5,{
					ImageTransparency = 0.5
				})
			end	
		end);

		local SearchInformation = {};

		local get_button = function(Name,Path,TAB_WARP)
			local ResultFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local FeatureName = Instance.new("TextLabel")
			local FeaturePath = Instance.new("TextLabel")

			ResultFrame.Name = Fatality:RandomString()
			ResultFrame.Parent = ScrollingFrame;
			ResultFrame.BackgroundColor3 = Fatality.Colors.Black
			ResultFrame.BackgroundTransparency = 1.000
			ResultFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ResultFrame.BorderSizePixel = 0
			ResultFrame.Size = UDim2.new(1, 0, 0, 42)
			ResultFrame.ZIndex = 103

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = ResultFrame

			FeatureName.Name = Fatality:RandomString()
			FeatureName.Parent = ResultFrame
			FeatureName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeatureName.BackgroundTransparency = 1.000
			FeatureName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeatureName.BorderSizePixel = 0
			FeatureName.Position = UDim2.new(0, 6, 0, 5)
			FeatureName.Size = UDim2.new(1, 0, 0, 15)
			FeatureName.ZIndex = 104
			FeatureName.FontFace = Fatality.FontSemiBold
			FeatureName.Text = Name
			FeatureName.TextColor3 = Color3.fromRGB(255, 255, 255)
			FeatureName.TextSize = 14.000
			FeatureName.TextXAlignment = Enum.TextXAlignment.Left

			FeaturePath.Name = Fatality:RandomString()
			FeaturePath.Parent = ResultFrame
			FeaturePath.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FeaturePath.BackgroundTransparency = 1.000
			FeaturePath.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FeaturePath.BorderSizePixel = 0
			FeaturePath.Position = UDim2.new(0, 6, 0, 22)
			FeaturePath.Size = UDim2.new(1, 0, 0, 15)
			FeaturePath.ZIndex = 104
			FeaturePath.FontFace = Fatality.FontSemiBold
			FeaturePath.Text = Path
			FeaturePath.TextColor3 = Color3.fromRGB(255, 255, 255)
			FeaturePath.TextSize = 12.000
			FeaturePath.TextTransparency = 0.500
			FeaturePath.TextXAlignment = Enum.TextXAlignment.Left

			local button = Fatality:NewInput(ResultFrame);

			Fatality:CreateHover(button,function(bool)
				if bool then
					Fatality:CreateAnimation(ResultFrame,0.5,{
						BackgroundTransparency = 0
					})
				else
					Fatality:CreateAnimation(ResultFrame,0.5,{
						BackgroundTransparency = 1
					})
				end	
			end);

			button.MouseButton1Click:Connect(function()
				if TAB_WARP then
					for i,v in next , Fatal.Menus do
						if v.Root == TAB_WARP.Root then
							Fatal.MenuSelected = v;
							v.ValueSelect(true)
						else
							v.ValueSelect(false)
						end;
					end;
				end;
			end);

			return ResultFrame;
		end

		SearchButton.MouseButton1Click:Connect(function()
			TextBox.Text = "";

			SearchToggle(true);

			table.clear(SearchInformation);

			table.foreach(ScrollingFrame:GetChildren(),function(i,v)
				if v:IsA('Frame') then
					v:Destroy();
				end;
			end);

			table.foreach(Fatal.ElementContents,function(i,v)
				local button = get_button(v.Name,v.Path,v._TAB);

				SearchInformation[v.Path.." - "..Fatality:RandomString()] = {
					root = button,
					callback = function()

					end,
				};
			end);
		end)

		local DearchDelay = tick();

		TextBox:GetPropertyChangedSignal('Text'):Connect(function()
			DearchDelay = tick();

			if not TextBox.Text:byte() then
				for i,v in next , SearchInformation do
					v.root.Visible = true;
				end;

				return;
			end;

			task.delay(0.5,function()
				if (tick() - DearchDelay) > 0.5 then
					for i,v in next , SearchInformation do
						if string.find(tostring(string.lower(i)),string.lower(TextBox.Text),1,true) then
							v.root.Visible = true;
						else
							v.root.Visible = false;
						end;
					end;
				end;
			end)
		end);

		UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if not Fatality:IsMouseOverFrame(SearchFrame) then
					SearchToggle(false);
				end
			end
		end)
	end;

	function Fatal:GetButton()
		local backpack = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")
		local RowLabel = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local StyledTextLabel = Instance.new("TextLabel")
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		local UIPadding = Instance.new("UIPadding")
		local IconHost = Instance.new("Frame")
		local IntegrationIconFrame = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local IntegrationIcon = Instance.new("ImageLabel")
		local SelectedHighlighter = Instance.new("Frame")
		local corner = Instance.new("UICorner")
		local Highlighter = Instance.new("Frame")
		local corner_2 = Instance.new("UICorner")
		local _5 = Instance.new("Frame")

		backpack.Name = "FATALITY"..Fatality:RandomString();
		backpack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		backpack.BackgroundTransparency = 1.000
		backpack.BorderSizePixel = 0
		backpack.LayoutOrder = 9
		backpack.Size = UDim2.new(1, 0, 0, 56)
		backpack.AutoButtonColor = false

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = backpack

		RowLabel.Name = "RowLabel"
		RowLabel.Parent = backpack
		RowLabel.BackgroundTransparency = 1.000
		RowLabel.BorderSizePixel = 0
		RowLabel.LayoutOrder = 9
		RowLabel.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout.Parent = RowLabel
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 8)

		StyledTextLabel.Name = "StyledTextLabel"
		StyledTextLabel.Parent = RowLabel
		StyledTextLabel.BackgroundTransparency = 1.000
		StyledTextLabel.Size = UDim2.new(1, -52, 1, 0)
		StyledTextLabel.Font = Enum.Font.BuilderSansBold
		StyledTextLabel.Text = Window.Name
		StyledTextLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
		StyledTextLabel.TextScaled = true
		StyledTextLabel.TextSize = 20.000
		StyledTextLabel.TextWrapped = true
		StyledTextLabel.TextXAlignment = Enum.TextXAlignment.Left

		UITextSizeConstraint.Parent = StyledTextLabel
		UITextSizeConstraint.MaxTextSize = 20
		UITextSizeConstraint.MinTextSize = 15

		UIPadding.Parent = RowLabel
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 8)

		IconHost.Name = "IconHost"
		IconHost.Parent = RowLabel
		IconHost.BackgroundTransparency = 1.000
		IconHost.BorderSizePixel = 0
		IconHost.LayoutOrder = 9
		IconHost.Size = UDim2.new(0, 44, 0, 44)
		IconHost.ZIndex = 9

		IntegrationIconFrame.Name = "IntegrationIconFrame"
		IntegrationIconFrame.Parent = IconHost
		IntegrationIconFrame.BackgroundTransparency = 1.000
		IntegrationIconFrame.BorderSizePixel = 0
		IntegrationIconFrame.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout_2.Parent = IntegrationIconFrame
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

		IntegrationIcon.Name = "IntegrationIcon"
		IntegrationIcon.Parent = IntegrationIconFrame
		IntegrationIcon.BackgroundTransparency = 1.000
		IntegrationIcon.Size = UDim2.new(0, 36, 0, 36)
		IntegrationIcon.Image = "http://www.roblox.com/asset/?id=11290237405"
		IntegrationIcon.ImageColor3 = Color3.fromRGB(247, 247, 248)

		SelectedHighlighter.Name = "SelectedHighlighter"
		SelectedHighlighter.Parent = IconHost
		SelectedHighlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		SelectedHighlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SelectedHighlighter.BackgroundTransparency = 0.850
		SelectedHighlighter.BorderSizePixel = 0
		SelectedHighlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		SelectedHighlighter.Size = UDim2.new(0, 36, 0, 36)
		SelectedHighlighter.Visible = false

		corner.CornerRadius = UDim.new(1, 0)
		corner.Name = "corner"
		corner.Parent = SelectedHighlighter

		Highlighter.Name = "Highlighter"
		Highlighter.Parent = IconHost
		Highlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		Highlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Highlighter.BackgroundTransparency = 0.850
		Highlighter.BorderSizePixel = 0
		Highlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		Highlighter.Size = UDim2.new(0, 36, 0, 36)
		Highlighter.Visible = false

		corner_2.CornerRadius = UDim.new(1, 0)
		corner_2.Name = "corner"
		corner_2.Parent = Highlighter

		_5.Name = "5"
		_5.Parent = IconHost
		_5.BackgroundTransparency = 1.000
		_5.Size = UDim2.new(1, 0, 1, 0)
		_5.ZIndex = 2

		backpack.MouseButton1Click:Connect(function()
			Fatal.Toggle = not Fatal.Toggle;

			ToggleUI(Fatal.Toggle);
		end);

		backpack.MouseEnter:Connect(function()
			Fatality:CreateAnimation(backpack,0.3,nil,{
				BackgroundColor3 = Fatality.Colors.Main,
				BackgroundTransparency = 0.85
			})
		end)

		backpack.MouseLeave:Connect(function()
			Fatality:CreateAnimation(backpack,0.3,nil,{
				BackgroundTransparency = 1
			})
		end)

		return backpack;
	end;

	function Fatal:SetVisible(b)
		Fatal.Toggle = b;
		ToggleUI(b);
	end;

	-- Watermark (draggable, click = open/close GUI) --
	do
		local Stats = game:GetService('Stats');
		local WatermarkGui = Instance.new("ScreenGui")
		local WFrame = Instance.new("Frame")
		local WCorner = Instance.new("UICorner")
		local WStroke = Instance.new("UIStroke")
		local WLine = Instance.new("Frame")
		local WPadding = Instance.new("UIPadding")
		local WText = Instance.new("TextLabel")

		WatermarkGui.Name = Fatality:RandomString()
		WatermarkGui.Parent = CoreGui
		WatermarkGui.ResetOnSpawn = false
		WatermarkGui.IgnoreGuiInset = true
		WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		WatermarkGui.Enabled = Window.Watermark
		protect_gui(WatermarkGui);

		WFrame.Name = Fatality:RandomString()
		WFrame.Parent = WatermarkGui
		WFrame.Active = true
		WFrame.AutomaticSize = Enum.AutomaticSize.X
		WFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
		WFrame.BackgroundTransparency = 0.1
		WFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		WFrame.BorderSizePixel = 0
		WFrame.ClipsDescendants = true
		WFrame.Position = UDim2.fromOffset(20, 60)
		WFrame.Size = UDim2.new(0, 0, 0, 24)
		WFrame.ZIndex = 5

		WCorner.CornerRadius = UDim.new(0, 3)
		WCorner.Parent = WFrame

		WStroke.Color = Color3.fromRGB(29, 29, 29)
		WStroke.Parent = WFrame

		WPadding.PaddingLeft = UDim.new(0, 10)
		WPadding.PaddingRight = UDim.new(0, 10)
		WPadding.Parent = WFrame

		WLine.Name = Fatality:RandomString()
		WLine.Parent = WFrame
		WLine.BackgroundColor3 = Fatality.Colors.Main
		WLine.BorderSizePixel = 0
		WLine.Position = UDim2.new(0, -10, 0, 0)
		WLine.Size = UDim2.new(1, 20, 0, 2)
		WLine.ZIndex = 6

		WText.Name = Fatality:RandomString()
		WText.Parent = WFrame
		WText.AutomaticSize = Enum.AutomaticSize.X
		WText.BackgroundTransparency = 1.000
		WText.BorderSizePixel = 0
		WText.Position = UDim2.new(0, 0, 0, 1)
		WText.Size = UDim2.new(0, 0, 1, -1)
		WText.ZIndex = 6
		WText.FontFace = Fatality.FontSemiBold
		WText.RichText = true
		WText.Text = ""
		WText.TextColor3 = Color3.fromRGB(255, 255, 255)
		WText.TextSize = 13.000
		WText.TextXAlignment = Enum.TextXAlignment.Center

		Fatality:CreateHover(WFrame,function(bool)
			if bool then
				Fatality:CreateAnimation(WStroke,0.3,{
					Color = Fatality.Colors.Main
				})
			else
				Fatality:CreateAnimation(WStroke,0.3,{
					Color = Color3.fromRGB(29, 29, 29)
				})
			end;
		end);

		-- drag + click --
		local WDragging, WMoved = false, false;
		local WDragStart, WStartPos;

		WFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				WDragging = true;
				WMoved = false;
				WDragStart = input.Position;
				WStartPos = WFrame.Position;
			end;
		end);

		UserInputService.InputChanged:Connect(function(input)
			if WDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - WDragStart;

				if delta.Magnitude > 4 then
					WMoved = true;
				end;

				if WMoved then
					WFrame.Position = UDim2.new(WStartPos.X.Scale, WStartPos.X.Offset + delta.X, WStartPos.Y.Scale, WStartPos.Y.Offset + delta.Y);
				end;
			end;
		end);

		UserInputService.InputEnded:Connect(function(input)
			if WDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				WDragging = false;

				if not WMoved then
					Fatal.Toggle = not Fatal.Toggle;

					ToggleUI(Fatal.Toggle);
				end;
			end;
		end);

		-- info (name | nick | ping | fps) --
		local GetPing = function()
			local ok, value = pcall(function()
				return Stats.Network.ServerStatsItem["Data Ping"]:GetValue();
			end);

			if ok and typeof(value) == "number" then
				return math.floor(value + 0.5);
			end;

			local ok2, ping = pcall(function()
				return Client:GetNetworkPing() * 1000;
			end);

			if ok2 and typeof(ping) == "number" then
				return math.floor(ping + 0.5);
			end;

			return 0;
		end;

		local Escape = function(text)
			return (tostring(text):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"));
		end;

		local Frames, LastTick = 0, tick();

		RunService.RenderStepped:Connect(function()
			Frames += 1;
		end);

		task.spawn(function()
			local Sep = '  <font transparency="0.6">|</font>  ';
			local Accent = "#" .. Fatality.Colors.Main:ToHex();

			while WatermarkGui.Parent do
				local now = tick();
				local fps = math.floor((Frames / math.max(now - LastTick, 0.001)) + 0.5);

				Frames = 0;
				LastTick = now;

				WText.Text = table.concat({
					string.format('<font color="%s">%s</font>', Accent, Escape(Window.Name)),
					Escape(Fatal.WatermarkNick or Client.DisplayName),
					GetPing() .. " ms",
					fps .. " fps",
				}, Sep);

				task.wait(0.5);
			end;
		end);

		function Fatal:SetWatermark(state: boolean)
			WatermarkGui.Enabled = state and true or false;
		end;
	end;

	ToggleUI(true);

	return Fatal;
end;

function Fatality:Loader(Config: Loader)
	Config = Config or {};
	Config.Name = Config.Name or "FATALITY";
	Config.Duration = Config.Duration or 3.5;
	Config.Scale = Config.Scale or 3;

	local Blur = Instance.new('BlurEffect');
	local Loader = Instance.new("ScreenGui")
	local center = Instance.new("Frame")
	local texts = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local BlackFrame = Instance.new("Frame")

	Loader.Name = Fatality:RandomString()
	Loader.Parent = CoreGui
	Loader.IgnoreGuiInset = true
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global

	center.Name = Fatality:RandomString()
	center.Parent = Loader
	center.AnchorPoint = Vector2.new(0.5, 0.5)
	center.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	center.BackgroundTransparency = 1.000
	center.BorderColor3 = Color3.fromRGB(0, 0, 0)
	center.BorderSizePixel = 0
	center.Position = UDim2.new(0.5, 0, 0.5, 0)

	texts.Name = Fatality:RandomString()
	texts.Parent = Loader
	texts.AnchorPoint = Vector2.new(0.5, 0.5)
	texts.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	texts.BackgroundTransparency = 1.000
	texts.BorderColor3 = Color3.fromRGB(0, 0, 0)
	texts.BorderSizePixel = 0
	texts.Position = UDim2.new(0.5, 0, 0.5, 0)
	texts.Size = UDim2.new(1, 0, 0, 200)

	UIListLayout.Parent = texts
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, Config.Scale * 5)

	BlackFrame.Name = Fatality:RandomString()
	BlackFrame.Parent = Loader
	BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BackgroundTransparency = 1
	BlackFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BorderSizePixel = 0
	BlackFrame.Size = UDim2.new(1, 0, 1, 0)

	Blur.Size = 0;
	Blur.Parent = game:GetService('Lighting');

	Fatality:CreateAnimation(Blur,1,{
		Size = 60
	})

	Fatality:CreateAnimation(BlackFrame,0.5,{
		BackgroundTransparency = 0.7
	}).Completed:Wait();

	task.wait(0.5);

	local UText = {
		Y = 14,
	};

	local createText = function(TEXT)
		local LIT = Instance.new("Frame")
		local ASCII = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local UIScale = Instance.new("UIScale")

		LIT.Name = Fatality:RandomString()
		LIT.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LIT.BackgroundTransparency = 1.000
		LIT.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LIT.BorderSizePixel = 0
		LIT.Size = UDim2.new(0, 56, 0, 100)
		LIT.ZIndex = 8

		ASCII.Name = Fatality:RandomString()
		ASCII.Parent = LIT
		ASCII.AnchorPoint = Vector2.new(0.5, 0.5)
		ASCII.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ASCII.BackgroundTransparency = 1.000
		ASCII.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ASCII.BorderSizePixel = 0
		ASCII.Position = UDim2.new(0.5, 0, 0.5, 0)
		ASCII.Size = UDim2.new(0, 28, 0, 50)
		ASCII.ZIndex = 8
		ASCII.Font = Enum.Font.GothamBold
		ASCII.Text = TEXT
		ASCII.TextColor3 = Color3.fromRGB(255, 255, 255)
		ASCII.TextSize = 50.000
		ASCII.TextWrapped = true

		local textsize = Fatality:GetTextSize(ASCII);

		ASCII.Size = UDim2.new(0, textsize.X + 100, 0, 50)
		LIT.Size = UDim2.new(0, (textsize.X * 2.5) + (UText[TEXT] or 0), 0, 100)

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 180, 70)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(190, 90, 0))}
		UIGradient.Rotation = 88
		UIGradient.Parent = ASCII

		UIScale.Parent = ASCII
		UIScale.Scale = Config.Scale

		return LIT,ASCII
	end;

	local PosText = {};
	local IsFirst = true;

	string.gsub(Config.Name,'.',function(T)
		local L,A = createText(T);

		L.Parent = texts;
		A.TextTransparency = 1;

		if not IsFirst then
			A.Position = UDim2.new(0.5,0,0.5,200);
		end;

		table.insert(PosText,{
			Frame = L,
			Text = A
		});

		IsFirst = false;
	end);

	do
		local StartText = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local UIScale = Instance.new("UIScale")

		StartText.Name = Fatality:RandomString()
		StartText.Parent = Loader
		StartText.AnchorPoint = Vector2.new(0.5, 0.5)
		StartText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		StartText.BackgroundTransparency = 1.000
		StartText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		StartText.BorderSizePixel = 0
		StartText.Position = UDim2.new(0.5, 0, 0.5, 0)
		StartText.Size = UDim2.new(0, 28, 0, 50)
		StartText.ZIndex = 8
		StartText.Font = Enum.Font.GothamBold
		StartText.Text = Config.Name:sub(1,1)
		StartText.TextColor3 = Color3.fromRGB(255, 255, 255)
		StartText.TextSize = 50.000
		StartText.TextWrapped = true
		StartText.TextTransparency = 1;

		local textsize = Fatality:GetTextSize(StartText);
		local baseSIZX = textsize.X;

		StartText.Size = UDim2.new(0, baseSIZX + 100, 0, 50)

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 180, 70)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(190, 90, 0))}
		UIGradient.Rotation = 88
		UIGradient.Parent = StartText

		UIScale.Parent = StartText
		UIScale.Scale = Config.Scale * 4;

		Fatality:CreateAnimation(StartText,0.45,{
			TextTransparency = 0
		})

		Fatality:CreateAnimation(UIScale,0.5,{
			Scale = Config.Scale;
		});

		task.wait(0.45);

		Fatality:CreateAnimation(StartText,0.35,{
			Position = UDim2.fromOffset(PosText[1].Frame.AbsolutePosition.X + (PosText[1].Frame.AbsoluteSize.X / 2),PosText[1].Frame.AbsolutePosition.Y + (PosText[1].Frame.AbsoluteSize.Y / 2) + math.abs(Loader.AbsolutePosition.Y))
		})

		task.wait(0.5);

		for i,v in next , PosText do
			if i > 1 then
				Fatality:CreateAnimation(v.Text,0.65,{
					Position = UDim2.new(0.5,0,0.5,0);
					TextTransparency = 0
				})
			end;
		end;

		task.wait((Config.Duration - 0.5) + 0.65);

		Fatality:CreateAnimation(StartText,1.5,{
			TextTransparency = 1
		})

		for i,v in next , PosText do
			Fatality:CreateAnimation(v.Text,1.5,{
				TextTransparency = 1
			})
		end;

		Fatality:CreateAnimation(Blur,1.5,{
			Size = 0
		})

		Fatality:CreateAnimation(BlackFrame,1.5,{
			BackgroundTransparency = 1
		})

		task.wait(1.65);

		Loader:Destroy();
	end;
end;

function Fatality:CreateNotifier(): Notifier
	if Fatality.__NOTIFIER_CACHE then return Fatality.__NOTIFIER_CACHE; end;

	local Notify = Instance.new("ScreenGui")
	local layout = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notify.Name = Fatality:RandomString();
	Notify.Parent = CoreGui
	Notify.ResetOnSpawn = false
	Notify.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Notify.IgnoreGuiInset = true;

	layout.Name = Fatality:RandomString();
	layout.Parent = Notify
	layout.AnchorPoint = Vector2.new(1, 0)
	layout.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	layout.BackgroundTransparency = 1.000
	layout.BorderColor3 = Color3.fromRGB(0, 0, 0)
	layout.BorderSizePixel = 0
	layout.Position = UDim2.new(1, -5, 0, 5)
	layout.Size = UDim2.new(0, 150, 0, 50)

	UIListLayout.Parent = layout
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local res = Fatality:CreateResponse({
		Notify = function(Config: Notify)
			Config = Config or {}
			Config.Icon = Config.Icon or "settings";
			Config.Content = Config.Content or nil;
			Config.Title = Config.Title or "Notification";
			Config.Duration = Config.Duration or 5;

			local notify = Instance.new("Frame")
			local notify_block = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local Icon = Instance.new("ImageLabel")
			local HeaderText = Instance.new("TextLabel")
			local BodyText = Instance.new("TextLabel")

			notify.Name = Fatality:RandomString()
			notify.Parent = layout
			notify.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			notify.BackgroundTransparency = 1.000
			notify.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify.BorderSizePixel = 0
			notify.Size = UDim2.new(0, 0, 0, 0)

			notify_block.Name = Fatality:RandomString()
			notify_block.Parent = notify
			notify_block.AnchorPoint = Vector2.new(0.5, 0)
			notify_block.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
			notify_block.BackgroundTransparency = 1
			notify_block.BorderColor3 = Color3.fromRGB(0, 0, 0)
			notify_block.BorderSizePixel = 0
			notify_block.Position = UDim2.new(0.5, 0, -1, 0)
			notify_block.Size = UDim2.new(1, 0, 1, -12)
			notify_block.ClipsDescendants = true
			notify_block.ZIndex = 54

			UICorner.CornerRadius = UDim.new(0, 3)
			UICorner.Parent = notify_block

			UIStroke.Thickness = 1
			UIStroke.Transparency = 1
			UIStroke.Parent = notify_block

			Icon.Name = Fatality:RandomString()
			Icon.Parent = notify_block
			Icon.BackgroundColor3 = Fatality.Colors.Main
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 7, 0, 7)
			Icon.Size = UDim2.new(0, 18, 0, 18)
			Icon.Image = Fatality:GetIcon(Config.Icon);
			Icon.ImageColor3 = Fatality.Colors.Main
			Icon.ImageTransparency = 1
			Icon.ZIndex = 55

			HeaderText.Name = Fatality:RandomString()
			HeaderText.Parent = notify_block
			HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HeaderText.BackgroundTransparency = 1.000
			HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HeaderText.BorderSizePixel = 0
			HeaderText.Position = UDim2.new(0, 30, 0, 7)
			HeaderText.Size = UDim2.new(1, 0, 0, 15)
			HeaderText.ZIndex = 55
			HeaderText.FontFace = Fatality.FontSemiBold
			HeaderText.Text = Config.Title
			HeaderText.TextColor3 = Fatality.Colors.Main
			HeaderText.TextSize = 13.000
			HeaderText.TextTransparency = 1
			HeaderText.TextXAlignment = Enum.TextXAlignment.Left

			BodyText.Name = Fatality:RandomString()
			BodyText.Parent = notify_block
			BodyText.AnchorPoint = Vector2.new(0, 1)
			BodyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			BodyText.BackgroundTransparency = 1.000
			BodyText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			BodyText.BorderSizePixel = 0
			BodyText.Position = UDim2.new(0, 10, 1, 0)
			BodyText.Size = UDim2.new(1, -15, 1, -29)
			BodyText.ZIndex = 55
			BodyText.FontFace = Fatality.FontSemiBold
			BodyText.Text = Config.Content or "";
			BodyText.TextColor3 = Color3.fromRGB(255, 255, 255)
			BodyText.TextSize = 12.000
			BodyText.TextTransparency = 1
			BodyText.TextWrapped = true
			BodyText.TextXAlignment = Enum.TextXAlignment.Left
			BodyText.TextYAlignment = Enum.TextYAlignment.Top

			local updateScale = function()
				local TitleScale = Fatality:GetTextSize(HeaderText,Enum.Font.GothamBold);
				local ContentScale = Fatality:GetTextSize(BodyText,Enum.Font.GothamMedium);

				local XScale = (TitleScale.X > ContentScale.X and TitleScale.X) or ContentScale.X;
				local YScale = (TitleScale.Y > ContentScale.Y and TitleScale.Y) or ContentScale.Y;

				notify.Size = UDim2.new(0, XScale + 25, 0, YScale + 50);

				Fatality:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 0, 0)
				});
			end;

			task.delay(0.1,function()
				Fatality:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 0.1
				})

				Fatality:CreateAnimation(UIStroke,0.25,{
					Thickness = 2.500,
					Transparency = 0.900
				})

				Fatality:CreateAnimation(Icon,0.25,{
					ImageTransparency = 0
				})

				Fatality:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 0.200
				})

				Fatality:CreateAnimation(BodyText,0.25,{
					TextTransparency = 0.3
				})
			end);

			updateScale();

			task.delay(Config.Duration + 0.25,function()
				Fatality:CreateAnimation(notify_block,0.35,{
					Position = UDim2.new(0.5, 0, 1, 0)
				})

				Fatality:CreateAnimation(notify_block,0.25,{
					BackgroundTransparency = 1
				})

				Fatality:CreateAnimation(UIStroke,0.25,{
					Thickness = 1,
					Transparency = 1
				})

				Fatality:CreateAnimation(Icon,0.25,{
					ImageTransparency = 1
				})

				Fatality:CreateAnimation(HeaderText,0.25,{
					TextTransparency = 1
				})

				Fatality:CreateAnimation(BodyText,0.25,{
					TextTransparency = 1
				})

				task.delay(0.35,function()
					Fatality:CreateAnimation(notify,0.5,{
						Size = UDim2.new(0,0,0,0)
					})

					task.wait(0.5)

					notify:Destroy();
				end);
			end)
		end,
	});

	Fatality.__NOTIFIER_CACHE = res;

	return res;
end;

Fatality.FATALITY_PID = Fatality:RandomString();

return Fatality;
end)();
local Notification = Fatality:CreateNotifier();

Fatality:Loader({
	Name = "FATALITY",
	Duration = 4
});

Notification:Notify({
	Title = "FATALITY",
	Content = "Hello, "..game.Players.LocalPlayer.DisplayName..' Welcome back!',
	Icon = "clipboard"
})

local Window = Fatality.new({
	Name = "FATALITY",
	Expire = "never",
});

getgenv().__FATAL_LIB = Fatality;
getgenv().__FATAL_WINDOW = Window;
getgenv().__FATAL_NOTIFIER = Notification;
end

local __ok, __err = xpcall(function(...)
-- Deobfuscated By Ron Luraph
local __S = {}

if not isfolder then
    function isfolder()
        return false
    end
end

if not makefolder then
    function makefolder()
    end
end

if not writefile then
    function writefile()
    end
end

if not readfile then
    function readfile()
        return nil
    end
end

local u796 = game
local u797 = workspace
local u798 = getgenv
__S[10] = hookmetamethod
__S[11] = newcclosure
local u799 = cloneref or function(r0) return r0 end
local u800 = getconnections
local u801 = getupvalues
local u802 = setupvalue
local u803 = getinfo
local u804 = islclosure
local u805 = checkcaller
local u806 = select
local u807 = unpack
local u808 = pcall
local u809 = type
local u810 = typeof
local u811 = pairs
local u812 = ipairs
__S[23] = assert
local u813 = warn
local u814 = tostring
local u815 = tonumber
__S[19] = rawget
local u816 = setmetatable
local u817 = tick
local u818 = Vector3
local u819 = CFrame
local u820 = Color3
local u821 = UDim2
local u822 = UDim
local u823 = Instance
local u824 = Enum
local u825 = table
local u826 = string
local u827 = math
local u828 = task
local u829 = os
local u830 = u799(u796:GetService("UserInputService"))
local u831 = u799(u796:GetService("ContentProvider"))
local u832 = u799(u796:GetService("TweenService"))
local u833 = u799(u796:GetService("HttpService"))
local u834 = u799(u796:GetService("TextService"))
u799(u796:GetService("RunService"))
u799(u796:GetService("Lighting"))
local u835 = u799(u796:GetService("Players"))
local u836 = u799(u796:GetService("CoreGui"))
u799(u796:GetService("Debris"))
local u837 = 0
local u838 = 0
local u839

local function u840(r0)
    u837 = u837 + 1
    local r1 = r0 or math.random(14, 22)
    local r2 = table.create(r1)

    for r3 = 1, r1 do
        local r8 = math.random(1, 63)

        if r3 == r1 then
            r8 = (r8 + u837 * 19 + r1 * 7) % 63 + 1
        end

        r2[r3] = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_", r8, r8)
    end

    return table.concat(r2)
end

local function u841(r0)
    u837 = u837 + 1
    local r1 = r0 or math.random(12, 18)
    local r2 = table.create(r1)

    for r3 = 1, r1 do
        local r8 = math.random(1, 63)

        if r3 == r1 then
            r8 = (r8 + u837 * 23) % 63 + 1
        end

        r2[r3] = string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_", r8, r8)
    end

    return table.concat(r2)
end

local u842 = u840(u827.random(14, 22))
local u843 = u841(u827.random(12, 18))

local function u844()
    local u845

    pcall(function()
        if typeof(gethui) ~= "function" then
            return
        end

        u845 = gethui()

        if u845 and typeof(u799) == "function" then
            u845 = u799(u845)
        end
    end)

    if u845 then
        return u845
    end

    return u836
end

local function u846(r0)
    r0(u844())
    r0(u836)
    r0(u835.LocalPlayer and u835.LocalPlayer:FindFirstChildOfClass("PlayerGui"))
end

local function u847(r0)
    u838 = u838 + 1
    local r1 = u823.new(r0)
    r1.Name = u840(math.random(14, 22))
    return r1
end

local u848 = {
    ScreenGui = true,
    BillboardGui = true,
    SurfaceGui = true,
    Frame = true,
    ScrollingFrame = true,
    TextLabel = true,
    TextButton = true,
    TextBox = true,
    ImageLabel = true,
    ImageButton = true,
    ViewportFrame = true,
    VideoFrame = true,
    CanvasGroup = true,
    Folder = true,
    UICorner = true,
    UIStroke = true,
    UIGradient = true,
    UIPadding = true,
    UIListLayout = true,
    UIGridLayout = true,
    UIAspectRatioConstraint = true,
    UITextSizeConstraint = true,
    UISizeConstraint = true,
    UIScale = true,
    UIPageLayout = true,
    UITableLayout = true
}

local function u849(r0, ...)
    if u848[r0] then
        return u847(r0)
    end

    return u823.new(r0, ...)
end

local u850 = u816({}, {
    __index = function(r0, r1)
        if r1 == "new" then
            return u849
        end

        return u823[r1]
    end
})

local function u851(r0)
    if not r0 then
        return
    end

    r0:SetAttribute(u843, u841(math.random(14, 22)))
    u839 = r0

    if u798 then
        u798()[u842] = r0
        u798()._AllusiveObfuscationRegistry = {GuiRoot = r0, GlobalKey = u842, MarkerAttribute = u843}
    end
end

local function u852()
    local r0 = u843

    u846(function(r0)
        if not r0 then
            return
        end

        for r3, r4 in r0:GetChildren() do
            if r4:IsA("ScreenGui") and r4:GetAttribute(u843) ~= nil then
                r4:Destroy()
            end
        end
    end)
end

local function u853()
    if not u798 then
        return
    end

    local u854 = u798()._AllusiveObfuscationRegistry

    if typeof(u854) ~= "table" then
        return
    end

    if typeof(u854.GuiRoot) == "Instance" and u854.GuiRoot.Parent then
        pcall(function()
            u854.GuiRoot:Destroy()
        end)
    end

    if typeof(u854.GlobalKey) == "string" then
        local u855 = u798()[u854.GlobalKey]

        if typeof(u855) == "Instance" and u855.Parent then
            pcall(function()
                u855:Destroy()
            end)
        end

        u798()[u854.GlobalKey] = nil
    end

    if typeof(u854.MarkerAttribute) == "string" then
        local u856 = u854.MarkerAttribute

        u846(function(r0)
            if not r0 then
                return
            end

            for r2, r3 in r0:GetChildren() do
                if r3:IsA("ScreenGui") and r3:GetAttribute(u856) ~= nil then
                    r3:Destroy()
                end
            end
        end)
    end
end

__S[7] = function()
    u853()
    u852()

    if u798 and u842 then
        local r2 = u798()[u842]

        if typeof(r2) == "Instance" and r2.Parent then
            r2:Destroy()
        end

        u798()[u842] = nil
    end

    if u839 and u839.Parent then
        u839:Destroy()
    end

    u839 = nil
end

local function u857()
    local r0 = u847("ScreenGui")
    r0.ResetOnSpawn = false
    r0.IgnoreGuiInset = true
    r0.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    r0.Parent = u844()
    u851(r0)
    return r0
end

local function u858()
    local r4 = u847("ScreenGui")
    r4.ResetOnSpawn = false
    r4.IgnoreGuiInset = true
    r4.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    r4:SetAttribute(u843, u841(math.random(14, 22)))
    r4.Parent = u844()
    return r4
end

local u859 = {new = u847}
local u860 = u835.LocalPlayer:GetMouse()

local u861 = {
    Language = {
        CheckboxEnabled = "Enabled",
        CheckboxDisabled = "Disabled",
        SliderValue = "Value",
        DropdownSelect = "Select",
        DropdownNone = "None",
        DropdownSelected = "Selected",
        ButtonClick = "Click",
        TextboxEnter = "Enter",
        ModuleEnabled = "Enabled",
        ModuleDisabled = "Disabled",
        TabGeneral = "General",
        TabSettings = "Settings",
        Loading = "Loading...",
        Error = "Error",
        Success = "Success"
    },
    Colors = {
        Background = u820.fromRGB(11, 11, 17),
        Card = u820.fromRGB(17, 17, 24),
        CardDeep = u820.fromRGB(13, 13, 20),
        Stroke = u820.fromRGB(36, 40, 58),
        StrokeHot = u820.fromRGB(72, 76, 130),
        Accent = u820.fromRGB(99, 102, 241),
        AccentDim = u820.fromRGB(55, 58, 190),
        AccentSoft = u820.fromRGB(172, 178, 255),
        AccentGlow = u820.fromRGB(99, 102, 241),
        Text = u820.fromRGB(235, 235, 245),
        SubText = u820.fromRGB(148, 152, 185),
        NotifyBg = u820.fromRGB(16, 16, 26),
        Danger = u820.fromRGB(240, 70, 70),
        Success = u820.fromRGB(72, 210, 140)
    },
    DefaultColors = {},
    Connections = u816({}, {
        __index = {
            disconnect = function(r0, r1)
                if not r0[r1] then
                    return
                end

                r0[r1]:Disconnect()
                r0[r1] = nil
            end,
            disconnect_all = function(r0)
                for r2, r3 in r0 do
                    if typeof(r3) ~= "function" then
                        r3:Disconnect()
                    end
                end
            end
        }
    }),
    Util = {
        map = function(r0, r1, r2, r3, r4, r5)
            return (r1 - r2) * (r5 - r4) / (r3 - r2) + r4
        end,
        viewport_point_to_world = function(r0, r1, r2)
            local r5 = u797.CurrentCamera:ScreenPointToRay(r1.X, r1.Y)
            return r5.Origin + r5.Direction * r2
        end,
        get_offset = function(r0)
            return r0:map(u797.CurrentCamera.ViewportSize.Y, 0, 2560, 8, 56)
        end
    },
    Library = {
        _all_modules = {},
        _config = nil,
        _choosing_keybind = false,
        _blocking_drag = false,
        _device = nil,
        _ui_open = true,
        _ui_scale = 1,
        _ui_loaded = false,
        _ui = nil,
        _dragging = false,
        _drag_start = nil,
        _container_position = nil,
        _tab = 0,
        _active_tab_ref = nil,
        _theme_container = nil,
        _theme_container_stroke = nil,
        _theme_vert_div = nil,
        _theme_search = nil,
        _theme_search_stroke = nil,
        _theme_client_grad = nil,
        _theme_pin = nil,
        _theme_logo = nil,
        _container_uiscale = nil,
        _applying_theme = false,
        _theme_pending = false,
        _theme_debounce = nil
    }
}

for r5_10, r6_6 in u811(u861.Colors) do
    u861.DefaultColors[r5_10] = r6_6
end

u798().GG = {Language = u861.Language}
local u862 = u861.Language
local u863 = u861.Connections
__S[3] = u861.Util
local u864 = u861.Library
u864.__index = u864
__S[7]()

local RealWindow = getgenv().__FATAL_WINDOW
local RealNotifier = getgenv().__FATAL_NOTIFIER
local RealFatality = getgenv().__FATAL_LIB

u864._config = {_flags = {}, _keybinds = {}, _library = {}, _gui = {}}

function u864.SendNotification(cfg)
	cfg = cfg or {}

	if not RealNotifier then
		return
	end

	pcall(function()
		RealNotifier:Notify({
			Title = tostring(cfg.title or "FATALITY"),
			Content = tostring(cfg.text or ""),
			Icon = "info",
			Duration = cfg.duration or 4,
		})
	end)
end

local u867 = {save = function() end}

do
	local flags = u864._config._flags

	local function cap(s)
		s = tostring(s or ""):gsub("_", " ")
		return s:sub(1, 1):upper() .. s:sub(2)
	end

	local function warnf(...)
		pcall(warn, "[fatality-port]", ...)
	end

	local function dead()
		local o = {}

		setmetatable(o, {
			__index = function()
				return function()
					return dead()
				end
			end,
		})

		return o
	end

	local function guard(label, fn)
		local ok, res = pcall(fn)

		if ok then
			return res
		end

		warnf("could not build '" .. tostring(label) .. "': " .. tostring(res))

		return dead()
	end

	local function iconFor(name, fallback)
		local ok, v = pcall(function()
			return RealFatality:GetIcon(name)
		end)

		if ok and v and v ~= "" then
			return name
		end

		return fallback or "settings"
	end

	local function copyList(t)
		local o = {}

		for i = 1, #t do
			o[i] = t[i]
		end

		return o
	end

	local function call(fn, ...)
		if type(fn) ~= "function" then
			return
		end

		local ok, err = pcall(fn, ...)

		if not ok then
			warnf("callback error", err)
		end
	end

	local function makeModule(sec, opts)
		local mod = {_state = false}

		local tog = sec:AddToggle({
			Name = "Enabled",
			Default = false,
			Flag = opts.flag,
			Callback = function(v)
				mod._state = v == true

				if opts.flag then
					flags[opts.flag] = mod._state
				end

				call(opts.callback, mod._state)
			end,
		})

		function mod:change_state(v)
			tog:SetValue(v == true)
		end

		function mod:create_slider(o)
			return guard(o.title, function()
				local min, max = o.minimum_value or 0, o.maximum_value or 100
				local dec = o.decimals or 0
				local def = math.max(min, math.min(max, o.value or min))
				local p = 10 ^ dec

				def = math.floor(def * p + 0.5) / p

				local r = sec:AddSlider({
					Name = cap(o.title),
					Min = min,
					Max = max,
					Default = def,
					Round = dec,
					Flag = o.flag,
					Callback = function(v)
						if o.flag then
							flags[o.flag] = v
						end

						call(o.callback, v)
					end,
				})

				if o.flag then
					flags[o.flag] = def
				end

				call(o.callback, def)

				local el = {}

				function el:set_percentage(v)
					r:SetValue(v)
				end

				return el
			end)
		end

		function mod:create_checkbox(o)
			return guard(o.title, function()
				local r = sec:AddToggle({
					Name = cap(o.title),
					Default = false,
					Flag = o.flag,
					Callback = function(v)
						if o.flag then
							flags[o.flag] = v
						end

						call(o.callback, v)
					end,
				})

				local el = {}

				function el:change_state(v)
					r:SetValue(v == true)
				end

				return el
			end)
		end

		function mod:create_doubleslider(o)
			return guard(o.title, function()
				local min, max = o.minimum_value or 0, o.maximum_value or 100
				local dec = o.decimals or 0
				local v = o.value or {min, max}
				local lo, hi = v[1] or min, v[2] or max

				local function fire()
					call(o.callback, math.min(lo, hi), math.max(lo, hi))
				end

				sec:AddSlider({
					Name = cap(o.title) .. " min",
					Min = min,
					Max = max,
					Default = lo,
					Round = dec,
					Flag = o.flag and (o.flag .. "_min"),
					Callback = function(x)
						lo = x
						fire()
					end,
				})
				sec:AddSlider({
					Name = cap(o.title) .. " max",
					Min = min,
					Max = max,
					Default = hi,
					Round = dec,
					Flag = o.flag and (o.flag .. "_max"),
					Callback = function(x)
						hi = x
						fire()
					end,
				})

				fire()

				return {}
			end)
		end

		function mod:create_dropdown(o)
			return guard(o.title, function()
				local multi = o.multi_dropdown == true
				local options = copyList(o.options or {})
				local def = multi and {} or options[1]

				local function ordered(map)
					local out = {}

					for k, x in pairs(map or {}) do
						if x == true and type(k) == "string" then
							out[#out + 1] = k
						end
					end

					local function idx(n)
						for i = 1, #options do
							if options[i] == n then
								return i
							end
						end

						return 1e9
					end

					table.sort(out, function(a, b)
						return idx(a) < idx(b)
					end)

					return out
				end

				local r = sec:AddDropdown({
					Name = cap(o.title),
					Values = options,
					Default = def,
					Multi = multi,
					Flag = o.flag,
					Callback = function(v)
						if multi then
							v = ordered(v)
						end

						if o.flag then
							flags[o.flag] = v
						end

						call(o.callback, v)
					end,
				})

				if not multi and options[1] ~= nil then
					call(o.callback, options[1])
				end

				local el = {}

				function el:set_options(list)
					pcall(function()
						r:SetData(copyList(list or {}))
					end)
				end

				return el
			end)
		end

		function mod:create_divider()
			return {}
		end

		function mod:create_textbox(o)
			return guard(o.title, function()
				local saved = o.flag and flags[o.flag]

				local r = sec:AddTextBox({
					Name = cap(o.title),
					Placeholder = o.placeholder or "",
					Default = type(saved) == "string" and saved or "",
					Flag = o.flag,
					Callback = function(t)
						if o.flag then
							flags[o.flag] = t
						end

						call(o.callback, t)
					end,
				})

				if type(saved) == "string" and saved ~= "" then
					call(o.callback, saved)
				end

				return {}
			end)
		end

		function mod:create_colorpicker(o)
			return guard(o.title, function()
				local def = o.value or Color3.new(1, 1, 1)

				local r = sec:AddColorPicker({
					Name = cap(o.title),
					Default = def,
					Flag = o.flag,
					Callback = function(c)
						call(o.callback, c)
					end,
				})

				call(o.callback, def)

				local el = {}

				function el:Set(c)
					r:SetValue(c)
				end

				return el
			end)
		end

		function mod:create_text() return {} end
		function mod:create_paragraph() return {} end
		function mod:create_feature() return {} end

		return mod
	end

	local lib = {}

	function lib:load() end

	function lib:create_tab(name, icon)
		local tab = {name = name, icon = icon}

		function tab:create_module(opts)
			return guard(opts.title, function()
				if not self.menu then
					self.menu = RealWindow:AddMenu({
						Name = string.upper(tostring(self.name)),
						Icon = iconFor(self.icon, "settings"),
						AutoFill = false,
					})
				end

				local sec = self.menu:AddSection({
					Name = string.upper(tostring(opts.title or "MODULE")),
					Position = opts.section == "right" and "center" or "left",
				})

				return makeModule(sec, opts)
			end)
		end

		return tab
	end

	__S[84] = lib
end

local u1054 = u799(u796:GetService("Players"))
local u1055 = u799(u796:GetService("RunService"))
local u1056 = u799(u796:GetService("UserInputService"))
local u1057 = u799(u796:GetService("ReplicatedStorage"))
local u1058 = u799(u796:GetService("Workspace"))
local u1059 = u799(u796:GetService("Stats"))
local u1060 = u850.new("VirtualInputManager")
u799(u796:GetService("InsertService"))
local u1061 = u1054.LocalPlayer
local u1062 = u1058.CurrentCamera
local u1063 = u1055.Heartbeat
local u1064 = u1055.RenderStepped
local u1065 = u1055.PreSimulation
u797 = u1058
local u1066 = u829.clock
local u1067 = u797:FindFirstChild("Runtime")
local u1068 = u796.PlaceId == 0
local u1069 = {}

local u1070 = {
    config = {
        auto_parry = false,
        accuracy = 75,
        randomize_accuracy = false,
        random_accuracy_min = 1,
        random_accuracy_max = 100,
        curve_mode = 2,
        parry_mode = "Remote",
        is_mobile = u1056.TouchEnabled and not u1056.MouseEnabled,
        target_player_enabled = false,
        target_player_name = nil,
        kill_pre_click = false,
        kill_pre_click_range = 30,
        kill_pre_click_speed = 1
    },
    detections = {
        infinity = false,
        deathslash = false,
        tornado_time = 0,
        slashesoffury = false,
        timehole = false
    },
    state = {
        grab_track = nil,
        ball_tracking = {},
        parried = false,
        infinity_active = false,
        deathslash_active = false,
        slashesoffury_active = false,
        timehole_active = false
    },
    curve_detection = {
        per_ball = {},
        curve_time = 0,
        velocity_history = {},
        dot_histories = {}
    },
    cache = {
        ping = 50,
        ping_t = 0,
        emotes_shared = nil,
        trove_module = nil
    },
    parry_cooldown = {
        failed_at = 0,
        duration = 2,
        last_parrying = nil,
        conn = nil,
        pending_id = 0,
        success_window = 0.75
    },
    triggerbot = {enabled = false, is_parrying = false, connection = nil},
    spam = {
        manual_enabled = false,
        auto_enabled = false,
        parries = 0,
        threshold = 1.5,
        sensitivity_multiplier = 1,
        connection_manual = nil,
        connection_auto = nil,
        animation_fix_manual = false,
        animation_fix_auto = false,
        manual_mode = "Remote",
        auto_mode = "Remote",
        remote_list = {},
        remote_list_dirty = true,
        auto_decay_at = {},
        ping_cache = 0,
        ping_cache_t = 0,
        balls_ref = nil,
        alive_ref = nil
    },
    ability = {cooldown_protection = false, auto_ability = false},
    mobile_guis = {triggerbot = nil, manual_spam = nil},
    ability_esp = {
        active = false,
        drawings = {},
        connection = nil,
        mode = "Text",
        show_name = false,
        name_mode = "Display Name",
        name_size = 18,
        name_color = u820.fromRGB(255, 255, 255),
        ability_size = 16,
        ability_color = u820.fromRGB(120, 200, 255),
        show_cd = true,
        cd_size = 15,
        cd_color = u820.fromRGB(180, 180, 180),
        show_timer = true,
        active_size = 15,
        active_color = u820.fromRGB(255, 200, 80)
    },
    ball_velocity = {
        active = false,
        gui = nil,
        peak = {},
        connection = nil
    },
    ball_indicator = {
        active = false,
        gui = nil,
        position = Vector2.new(0, 0),
        rotation = 0,
        connection = nil,
        size = u1056.TouchEnabled and not u1056.MouseEnabled and 30 or 40,
        distance = u1056.TouchEnabled and not u1056.MouseEnabled and 70 or 90
    },
    no_render = {active = false, connection = nil},
    plushies = {
        active = false,
        active_types = {},
        folder = nil,
        connection = nil,
        loaded_models = {},
        models = {
            Reimu = "rbxassetid://17657672380",
            Youmou = "rbxassetid://13242826151",
            Shion = "rbxassetid://12124164278",
            Yuuka = "rbxassetid://12181667428",
            Flandre = "rbxassetid://12136125365",
            Ayanami = "rbxassetid://11965563704",
            Padoru = "rbxassetid://11905337091"
        },
        scales = {
            Reimu = 1.5,
            Youmou = 2.3,
            Shion = 2.3,
            Yuuka = 1.5,
            Flandre = 3.3,
            Ayanami = 1.5,
            Padoru = 1.5
        },
        rotations = {
            Reimu = u819.Angles(0, u827.rad(0), 0),
            Youmou = u819.Angles(0, u827.rad(-90), 0),
            Shion = u819.Angles(u827.rad(110), 0, u827.rad(90)),
            Yuuka = u819.Angles(u827.rad(-90), u827.rad(180), 0),
            Flandre = u819.Angles(0, u827.rad(-40), 0),
            Ayanami = u819.Angles(0, 0, 0),
            Padoru = u819.Angles(0, 0, 0)
        },
        positions = {
            u818.new(2.5, 2, 0),
            u818.new(-2.5, 2, 0),
            u818.new(0, 4, 2.5),
            u818.new(0, 4, -2.5),
            u818.new(2.5, 2, 2.5),
            u818.new(-2.5, 2, 2.5),
            u818.new(2.5, 2, -2.5)
        }
    },
    remote = {},
    animation = {},
    ball = {},
    player = {},
    curve = {},
    parry = {},
    sword_changer = {
        original = {model = nil, saved = false},
        model_cache = {},
        swords_controller = nil,
        parry_func = nil,
        loaded = false,
        enabled = false,
        model = "",
        animations = "",
        fx = "",
        slash_name = "SlashEffect",
        update = nil
    },
    avatar_changer = {
        applying = false,
        applied_id = nil,
        cache = {},
        original_desc = nil,
        enabled = false,
        target = "",
        respawn_token = 0,
        expected_accessories = 0
    },
    emotes = {
        storage = {},
        current = nil,
        trove = nil,
        enabled = false,
        auto_stop = false,
        paused = false,
        _replay_t = 0,
        _loop_t = 0,
        connection = nil
    },
    avatar = {
        korblox_enabled = false,
        headless_enabled = false,
        korblox_conn = nil,
        headless_conn = nil
    },
    parry_visualizer = {
        active = false,
        color = u820.fromRGB(255, 255, 255),
        parts = {},
        connection = nil,
        char_conn = nil,
        sphere = nil,
        weld = nil
    },
    parry_hits = {active = false, color = u820.fromRGB(255, 255, 255), parts = {}},
    player_mods = {
        fov_enabled = false,
        fov = 70,
        speed_enabled = false,
        speed = 16,
        gravity_enabled = false,
        gravity = 196.2,
        jump_power_enabled = false,
        jump_power = 50,
        infinite_jump_enabled = false,
        infinite_jump_conn = nil,
        speed_conn = nil,
        jump_conn = nil
    },
    ball_trail = {
        active = false,
        color = u820.fromRGB(0, 255, 255),
        num_trails = 8,
        attachments = {},
        connection = nil
    },
    orbit_ball = {
        active = false,
        speed = 50,
        height = 5,
        distance = 15,
        angle = 0,
        connection = nil
    },
    winstreak = {
        enabled = false,
        streak = "1",
        conn = nil,
        enabled_conn = nil,
        char_conn = nil,
        original_text = nil,
        original_icon = nil,
        original_enabled = nil
    },
    custom_win = {
        enabled = false,
        win_message = "Allusive",
        kill_message = "Allusive",
        connections = {}
    },
    immortal = {
        config = {
            radius = 25,
            height = 30,
            angles = 360,
            visualizer_enabled = false,
            visualizer_color = u820.fromRGB(255, 0, 0)
        },
        state = {
            enabled = false,
            notify = false,
            connections = {},
            cache = {
                character = nil,
                hrp = nil,
                head = nil,
                alive = nil,
                original_cframe = nil,
                original_velocity = nil
            },
            visualizer = {parts = {}, folder = nil}
        },
        constants = {empty_cframe = u819.new(), velocity = u818.new(1, 1, 1)}
    },
    staff_detection = {mode = "Notify"},
    slashesoffury_detection = {max_parries = 36, parry_delay = 0.05},
    phantom = {
        enabled = false,
        mode = "Ability",
        range = 130,
        active = false
    }
}

__S[3] = function()
    local r4 = u1061.Character

    if r4 == u1070.immortal.state.cache.character then
        return
    end

    u1070.immortal.state.cache.character = r4

    if r4 then
        u1070.immortal.state.cache.hrp = r4:FindFirstChild("HumanoidRootPart")
        u1070.immortal.state.cache.head = r4:FindFirstChild("Head")
        u1070.immortal.state.cache.alive = u797:FindFirstChild("Alive")
    else
        u1070.immortal.state.cache.hrp = nil
        u1070.immortal.state.cache.head = nil
    end
end

u1070.immortal.update_cache = __S[3]

__S[3] = function()
    return u1070.immortal.state.cache.alive and u1070.immortal.state.cache.character and u1070.immortal.state.cache.character.Parent == u1070.immortal.state.cache.alive
end

u1070.immortal.is_in_alive = __S[3]

__S[3] = function()
    if not u1070.immortal.state.cache.hrp then
        return u819.new()
    end

    local r3 = u1070.immortal.state.cache.hrp
    local r4 = r3.Position
    local r0 = (nil)(math.random(0, u1070.immortal.config.angles))
    local r5 = u1070.immortal.config.radius
    local r2 = math.floor(u817() * 11.9) % 2 == 0 and 0 or u1070.immortal.config.height
    local r1 = r4.X + math.cos(r0) * r5
    r2 = r4.Y - r3.Size.Y * 0.5 + 5 + r2
    local r3_2 = r4.Z + math.sin(r0) * r5
    return u819.new(r1, r2, r3_2)
end

u1070.immortal.get_random_position = __S[3]

__S[3] = function()
    if u1070.immortal.state.visualizer.folder then
        u1070.immortal.state.visualizer.folder:Destroy()
    end

    local r0 = u850.new("Folder")
    r0.Name = "ImmortalVisualizer"
    r0.Parent = u797
    u1070.immortal.state.visualizer.folder = r0
end

u1070.immortal.create_visualizer = __S[3]

__S[3] = function(r0)
    if not u1070.immortal.config.visualizer_enabled or not u1070.immortal.state.visualizer.folder then
        return
    end

    for r2, r3 in ipairs(u1070.immortal.state.visualizer.parts) do
        if r3 and r3.Parent then
            r3:Destroy()
        end
    end

    u1070.immortal.state.visualizer.parts = {}
    local r2_2 = u850.new("Part")
    r2_2.Size = Vector3.new(2, 0.5, 2)
    r2_2.CFrame = r0
    r2_2.Anchored = true
    r2_2.CanCollide = false
    r2_2.Material = u824.Material.Neon
    r2_2.Color = u1070.immortal.config.visualizer_color
    r2_2.Transparency = 0.5
    r2_2.Parent = u1070.immortal.state.visualizer.folder
    table.insert(u1070.immortal.state.visualizer.parts, r2_2)
    u796:GetService("Debris"):AddItem(r2_2, 0.1)
end

u1070.immortal.update_visualizer = __S[3]

__S[3] = function()
    if u1070.immortal.state.visualizer.folder then
        u1070.immortal.state.visualizer.folder:Destroy()
        u1070.immortal.state.visualizer.folder = nil
    end

    u1070.immortal.state.visualizer.parts = {}
end

u1070.immortal.destroy_visualizer = __S[3]

__S[6] = function()
    u1070.immortal.update_cache()

    if not u1070.immortal.state.enabled or not u1070.immortal.state.cache.hrp or not u1070.immortal.is_in_alive() then
        return
    end

    local v1 = u1070.immortal.state.cache.hrp
    u1070.immortal.state.cache.original_cframe = v1.CFrame
    u1070.immortal.state.cache.original_velocity = v1.AssemblyLinearVelocity
    local v2 = u1070.immortal.get_random_position()
    v1.CFrame = v2
    v1.AssemblyLinearVelocity = u1070.immortal.constants.velocity

    if u1070.immortal.config.visualizer_enabled then
        u1070.immortal.update_visualizer(v2)
    end

    u1064:Wait()
    v1.CFrame = u1070.immortal.state.cache.original_cframe
    v1.AssemblyLinearVelocity = u1070.immortal.state.cache.original_velocity
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.immortal.perform_desync = __S[6]

__S[3] = function()
    u1070.immortal.state.cache.character = nil
    u1070.immortal.state.cache.hrp = nil

    u1070.immortal.state.cache.head = nil
    u1070.immortal.state.cache.alive = nil
    u1070.immortal.state.cache.original_cframe = nil
    u1070.immortal.state.cache.original_velocity = nil
end

u1070.immortal.reset_cache = __S[3]

__S[3] = function()
    if u1070.immortal.state.enabled then
        return
    end

    u1070.immortal.state.enabled = true

    if u1070.immortal.config.visualizer_enabled then
        u1070.immortal.create_visualizer()
    end

    if not u1070.immortal.state.connections.heartbeat then
        u1070.immortal.state.connections.heartbeat = u1063:Connect(u1070.immortal.perform_desync)
    end
end

u1070.immortal.start = __S[3]

__S[3] = function()
    if not u1070.immortal.state.enabled then
        return
    end

    u1070.immortal.state.enabled = false

    if u1070.immortal.state.connections.heartbeat then
        u1070.immortal.state.connections.heartbeat:Disconnect()
        u1070.immortal.state.connections.heartbeat = nil
    end

    u1070.immortal.destroy_visualizer()
    u1070.immortal.reset_cache()
end

u1070.immortal.stop = __S[3]

u1061.CharacterAdded:Connect(function(r0)
    if not u1070.immortal.state.enabled then
        return
    end

    task.wait(1)
    u1070.immortal.reset_cache()

    if u1070.immortal.state.connections.heartbeat then
        u1070.immortal.state.connections.heartbeat:Disconnect()
    end

    u1070.immortal.state.connections.heartbeat = u1063:Connect(u1070.immortal.perform_desync)

    if u1070.immortal.config.visualizer_enabled then
        u1070.immortal.create_visualizer()
    end
end)

local u1071

__S[3] = function(v1, v2)
    if not u1070.immortal.state.enabled or (u805()) or v2 ~= "CFrame" or not u1070.immortal.state.cache.hrp or not u1070.immortal.is_in_alive() then
        return u1071(v1, v2)
    end

    if v1 == u1070.immortal.state.cache.hrp then
        return u1070.immortal.state.cache.original_cframe or u1070.immortal.constants.empty_cframe
    elseif v1 == u1070.immortal.state.cache.head and u1070.immortal.state.cache.original_cframe then
        local v3 = u818.new(0, u1070.immortal.state.cache.hrp.Size.Y * 0.5 + 0.5, 0)
        return u1070.immortal.state.cache.original_cframe + v3
    end

    return u1071(v1, v2)
end --[[ LPH_NO_VIRTUALIZE ]]

if __S[10] and __S[11] then
    u1071 = __S[10](u796, "__index", __S[11](__S[3]))
end

__S[3] = function()
    local r0 = u1057:FindFirstChild("Misc")

    if not r0 then
        return
    end

    local r4 = r0:FindFirstChild("Emotes")

    if not r4 then
        return
    end

    local r292 = r4:GetChildren()

    for r1, r2 in pairs(r292) do
        if r2:IsA("Animation") and r2:GetAttribute("EmoteName") then
            local r3 = r2:GetAttribute("EmoteName")
            u1070.emotes.storage[r3] = r2
        end
    end
end

u1070.emotes.load_animations = __S[3]

__S[3] = function()
    local r3 = {}

    for r1, r2 in pairs(u1070.emotes.storage) do
        table.insert(r3, r1)
    end

    table.sort(r3)
    return r3
end

u1070.emotes.get_emotes_list = __S[3]

__S[6] = function()
    if u1070.cache.emotes_shared ~= nil then
        return u1070.cache.emotes_shared or nil
    end

    local v1 = u1057:FindFirstChild("Shared")
    local v2 = v1 and (v1:FindFirstChild("EmotesShared"))

    if not v2 then
        u1070.cache.emotes_shared = false
        return nil
    end

    v1 = getthreadidentity()
    setthreadidentity(6)
    local v3, v4 = u808(require, v2)
    setthreadidentity(v1)

    if v3 and u809(v4) == "table" and u809(v4.Play) == "function" then
        u1070.cache.emotes_shared = v4
    end

    if not (v3 and u809(v4) == "table" and u809(v4.Play) == "function") then
        u1070.cache.emotes_shared = false
    end

    return u1070.cache.emotes_shared or nil
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.emotes.get_shared = __S[6]

__S[6] = function()
    if u1070.cache.trove_module ~= nil then
        return u1070.cache.trove_module or nil
    end

    local v1 = u1057:FindFirstChild("Packages")
    local v2 = v1 and (v1:FindFirstChild("Trove"))

    if not v2 then
        u1070.cache.trove_module = false
        return nil
    end

    local v3, v4 = u808(require, v2)

    if v3 and u809(v4) == "table" and u809(v4.new) == "function" then
        u1070.cache.trove_module = v4
    end

    if not (v3 and u809(v4) == "table" and u809(v4.new) == "function") then
        u1070.cache.trove_module = false
    end

    return u1070.cache.trove_module or nil
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.emotes.get_trove_module = __S[6]

__S[3] = function(r0)
    local u1072 = u1070.emotes

    if u1072.trove then
        pcall(function()
            u1072.trove:Destroy()
        end)

        u1072.trove = nil
    end

    if not r0 then
        u1072.current = nil
        u1072.paused = false
    end
end

u1070.emotes._stop_track = __S[3]

__S[6] = function(v1)
    local v2 = u1070.emotes.storage[v1]

    if not v2 then
        return false
    end

    local v3 = u1061.Character

    if not v3 or not v3.PrimaryPart then
        return false
    end

    if not v3:FindFirstChildWhichIsA("Humanoid") then
        return false
    end

    local v4, v5 = u1070.emotes.get_shared(), u1070.emotes.get_trove_module()

    if not v4 or not v5 then
        return false
    end

    u1070.emotes._stop_track(false)
    u1070.emotes.paused = false
    u1070.emotes.trove = v5.new()
    u1070.emotes.current = v1

    if not u808(function()
        v4:Play(v3, u1070.emotes.trove, v2.Name, true, u1058:GetServerTimeNow(), nil)
    end) then
        u1070.emotes._stop_track(false)
        return false
    end

    return true
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.emotes.play = __S[6]

__S[6] = function(v1)
    if u809(v1) ~= "string" or v1 == "" then
        return false
    end

    local v2 = u1061.Character

    if not v2 or not v2.PrimaryPart then
        return false
    end

    if not v2:FindFirstChildWhichIsA("Humanoid") then
        return false
    end

    local v3, v4 = u1070.emotes.get_shared(), u1070.emotes.get_trove_module()

    if not v3 or not v4 then
        return false
    end

    u1070.emotes._stop_track(false)
    u1070.emotes.paused = false
    u1070.emotes.trove = v4.new()
    u1070.emotes.current = v1

    if not u808(function()
        v3:Play(v2, u1070.emotes.trove, v1, true, u1058:GetServerTimeNow(), nil)
    end) then
        u1070.emotes._stop_track(false)
        return false
    end

    return true
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.emotes.play_internal = __S[6]

__S[3] = function()
    u1070.emotes._stop_track(false)
end

u1070.emotes.stop = __S[3]

__S[6] = function()
    local v1 = u1070.emotes

    if not v1.enabled or not v1.current then
        return
    end

    local v2 = u1066()

    if v2 - v1._loop_t < 0.08 then
        return
    end

    v1._loop_t = v2
    local v3 = u1061.Character

    if not v3 then
        return
    end

    local v4 = v3.PrimaryPart

    if not v4 then
        return
    end

    v3 = v4.AssemblyLinearVelocity.Magnitude > 2

    if v1.auto_stop then
        if v3 then
            if not v1.paused then
                v1._stop_track(true)
                v1.paused = true
            end
        elseif v1.paused then
            v1.paused = false
            v1.play(v1.current)
        end

        return
    end

    if not v1.trove then
        if v2 - v1._replay_t >= 0.3 then
            v1._replay_t = v2
            v1.play(v1.current)
        end
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.emotes.update_loop = __S[6]

__S[3] = function()
    u1070.emotes.enabled = true

    if not u1070.emotes.connection then
        local function r2()
            if u1070.emotes.enabled then
                u1070.emotes.update_loop()
            end
        end --[[ LPH_NO_VIRTUALIZE ]]

        u1070.emotes.connection = u1055.Heartbeat:Connect(r2)
    end

    if u1070.emotes.current then
        u1070.emotes.play(u1070.emotes.current)
    end
end

u1070.emotes.start = __S[3]

__S[3] = function()
    u1070.emotes.enabled = false
    local r0 = u1070.emotes.current
    u1070.emotes.stop()
    u1070.emotes.current = r0

    if u1070.emotes.connection then
        u1070.emotes.connection:Disconnect()
        u1070.emotes.connection = nil
    end
end

u1070.emotes.cleanup = __S[3]
u1070.emotes.load_animations()
local u1073 = {"Camera", "Random", "Accelerated", "Back", "Down", "Up", "Dot"}

local function u1074()
    local function r1()
        return u1059.Network.ServerStatsItem["Data Ping"]:GetValue()
    end

    local r0, r1_2 = pcall(r1)
    return r0 and r1_2 or 50
end

__S[6] = function()
    local v1 = u1070.cache
    local v2 = u1066()

    if v2 - v1.ping_t >= 0.12 then
        v1.ping = u1074()
        v1.ping_t = v2
    end

    return v1.ping
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.cache.get_ping = __S[6]

local function u1075()
    if u1070.config.is_mobile then
        u1060:SendMouseButtonEvent(0, 0, 0, true, u796, 0)
        u1060:SendMouseButtonEvent(0, 0, 0, false, u796, 0)
    else
        u1060:SendKeyEvent(true, u824.KeyCode.F, false, u796)
        u1060:SendKeyEvent(false, u824.KeyCode.F, false, u796)
    end
end

local function u1076()
    if u1070.config.curve_mode == 1 and u1070.config.parry_mode == "Keypress" then
        u1075()
        return
    end

    local r0 = u1070.curve.get_cframe()
    local r8 = u1062.CFrame
    u1062.CFrame = r0

    if u1070.config.is_mobile then
        u1060:SendMouseButtonEvent(0, 0, 0, true, u796, 0)
        u1060:SendMouseButtonEvent(0, 0, 0, false, u796, 0)
    else
        u1060:SendKeyEvent(true, u824.KeyCode.F, false, u796)
        u1060:SendKeyEvent(false, u824.KeyCode.F, false, u796)
    end

    u1064:Wait()
    u1062.CFrame = r8
end

local function u1077(u1078)
    local r2 = tonumber(u1078)

    if r2 then
        return r2
    end

    local function r4()
        return u1054:GetUserIdFromNameAsync(tostring(u1078))
    end

    local r3, r4_2 = pcall(r4)
    return r3 and r4_2 or nil
end

local function u1079(r0, r1, r2)
    local r8 = u858()
    local u1080 = u847("TextButton")
    u1080.Size = u821.new(0, 120, 0, 48)
    u1080.Position = u821.new(0.5, -60, r1, 0)
    u1080.BackgroundTransparency = 1
    u1080.AnchorPoint = Vector2.new(0.5, 0)
    u1080.AutoButtonColor = false
    u1080.ZIndex = 2
    u1080.Text = ""
    u1080.Parent = r8
    local r10 = u847("Frame")
    r10.Size = u821.new(1, 0, 1, 0)
    r10.BackgroundColor3 = u820.fromRGB(18, 18, 24)
    r10.BorderSizePixel = 0
    r10.Parent = u1080
    local r6 = u847("UICorner")
    r6.CornerRadius = u822.new(0, 10)
    r6.Parent = r10
    local r3 = u847("UIStroke")
    r3.Color = r2
    r3.Thickness = 1.5
    r3.Transparency = 0.3
    r3.Parent = r10
    local r10_2 = u847("TextLabel")
    r10_2.Size = u821.new(1, 0, 1, 0)
    r10_2.BackgroundTransparency = 1
    r10_2.Text = r0
    r10_2.Font = u824.Font.GothamBold
    r10_2.TextSize = 14
    r10_2.TextColor3 = u820.fromRGB(235, 235, 245)
    r10_2.ZIndex = 3
    r10_2.Parent = u1080
    local u1081 = false
    local u1082
    local u1083

    u1080.InputBegan:Connect(function(r0)
        if r0.UserInputType == u824.UserInputType.Touch then
            u1081 = true
            u1082 = r0.Position
            u1083 = u1080.Position
        end
    end)

    u1080.InputChanged:Connect(function(r0)
        local r2 = u1081

        if not u1081 or r0.UserInputType ~= u824.UserInputType.Touch then
            return
        end

        local r1 = r0.Position - u1082

        if r1.Magnitude > 8 then
            u1080.Position = u821.new(u1083.X.Scale, u1083.X.Offset + r1.X, u1083.Y.Scale, u1083.Y.Offset + r1.Y)
        end
    end)

    u1080.InputEnded:Connect(function(r0)
        if r0.UserInputType == u824.UserInputType.Touch then
            u1081 = false
        end
    end)

    return {gui = r8, button = u1080, label = r10_2}
end

local u1084 = u1057

u808(function()
    u1084.Remotes.DeathBall.OnClientEvent:Connect(function(r0, r1)
        u1070.state.deathslash_active = r1 or false
    end)
end)

u808(function()
    u1084.Remotes.InfinityBall.OnClientEvent:Connect(function(r0, r1)
        u1070.state.infinity_active = r1 or false
    end)
end)

u808(function()
    local r1 = u1084.Remotes.ParrySuccessAll.OnClientEvent
    local u1085 = r1.Connect

    u1085(r1, function(r0, r1)
        local r2 = u1061.Character

        if not r2 or not r2.PrimaryPart then
            return
        end

        local r10 = r2.PrimaryPart
        local r5 = u797:FindFirstChild("Balls")

        if not r5 then
            return
        end

        local r296 = r5:GetChildren()

        for r3, r0_2 in ipairs(r296) do
            if r0_2:IsA("BasePart") then
                local r4 = r0_2:FindFirstChild("zoomies")

                if r4 then
                    local r5_2 = r4.VectorVelocity.Magnitude
                    local r12 = (r10.Position - r0_2.Position).Magnitude
                    local r13 = u1070.cache.get_ping()
                    local r4_2 = r12 / math.max(r5_2, 1) - r13 / 1000
                    local r6 = math.min(r5_2 / 100, 40)
                    r6 = 15 - math.min(r12 / 1000, 15) + r6

                    if r5_2 > 1 and r13 / 10 < r4_2 then
                        r6 = math.max(r6 - 15, 15)
                    end

                    if r1 == r10 then
                        break
                    end

                    if not (r6 < r12) then
                        break
                    end

                    u1070.curve_detection.curve_time = u817()
                    break
                end
            end
        end
    end)
end)

u808(function()
    u1061.AttributeChanged:Connect(function(r0)
        if r0 == "TimeHoleActivate" then
            u1070.state.timehole_active = u1061:GetAttribute("TimeHoleActivate") ~= nil
        end
    end)
end)

u808(function()
    local u1086 = u1084.Remotes.AbilityButtonPress
    local r1 = u1084.Remotes.Phantom.OnClientEvent
    local u1087 = r1.Connect

    u1087(r1, function(...)
        local r9 = {...}
        local r1 = r9[2]

        if typeof(r1) ~= "Instance" then
            return
        end

        if r1.Name ~= u1061.Name then
            return
        end

        if not u1070.phantom.enabled then
            return
        end

        local r9_2 = u1061.Character

        if not r9_2 then
            return
        end

        local r8 = r9_2:FindFirstChild("HumanoidRootPart")

        if not r8 then
            return
        end

        local r5 = u1070.phantom.range
        local r293 = u1070.ball.get_all()
        local r6

        for r2, r3 in ipairs(r293) do
            local r7 = (r3.part.Position - r8.Position).Magnitude

            if r7 <= r5 then
                r5 = r7
                r6 = r3
            end
        end

        if not r6 then
            return
        end

        u1070.phantom.active = true

        if u1070.phantom.mode == "Ability" then
            u1086:Fire()

            task.delay(1, function()
                u1070.phantom.active = false
            end)
        elseif u1070.phantom.mode == "Teleport" then
            u1070.parry.execute()
            r8.CFrame = u819.new(r6.part.Position)

            task.delay(0.5, function()
                u1070.phantom.active = false
            end)
        end
    end)
end)

local u1088

local function u1089(u1090)
    if u1088 then
        u1088:Disconnect()
        u1088 = nil
    end

    u1088 = u1090.AttributeChanged:Connect(function(r0)
        if r0 == "AbilityActive" then
            local r6 = u1090:GetAttribute("AbilityActive")

            if u1061:GetAttribute("CurrentlyEquippedAbility") == "Slashes of Fury" and r6 == true then
                u1070.state.slashesoffury_active = true
            else
                u1070.state.slashesoffury_active = false
            end
        end

        if r0 ~= "FuryCatch" then
            return
        end

        if u1090:GetAttribute("FuryCatch") == nil then
            return
        end

        if not u1070.detections.slashesoffury then
            return
        end

        task.spawn(function()
            local r0 = 0

            while u1070.state.slashesoffury_active and r0 < u1070.slashesoffury_detection.max_parries and u1070.detections.slashesoffury do
                r0 = r0 + 1
                u1070.parry.execute()
                task.wait(u1070.slashesoffury_detection.parry_delay)
            end
        end)
    end)
end

if u1061.Character then
    u808(u1089, u1061.Character)
end

u1061.CharacterAdded:Connect(function(r0)
    pcall(u1089, r0)
end)

__S[3] = function()
    if u1070.avatar_changer.original_desc then
        return
    end

    local u1109 = u1070.avatar_changer.saving_original

    if u1109 then
        return
    end

    u1070.avatar_changer.saving_original = true

    task.spawn(function()
        for r2 = 1, 5 do
            local function r1()
                return u1054:GetHumanoidDescriptionFromUserIdAsync(u1061.UserId)
            end

            local r0, r1_2 = pcall(r1)

            if r0 and r1_2 then
                u1070.avatar_changer.original_desc = r1_2
                break
            end

            task.wait(0.3 * r2)
        end

        u1070.avatar_changer.saving_original = false
    end)
end

u1070.avatar_changer.save_original = __S[3]

__S[3] = function(u1110)
    if u1070.avatar_changer.cache[u1110] then
        return u1070.avatar_changer.cache[u1110]
    end

    for r2 = 1, 5 do
        local function r6()
            return u1054:GetHumanoidDescriptionFromUserIdAsync(u1110)
        end

        local r5, r6_2 = pcall(r6)

        if r5 and r6_2 then
            u1070.avatar_changer.cache[u1110] = r6_2
            return r6_2
        elseif r2 < 5 then
            task.wait(0.2 * r2)
        end
    end

    return nil
end

u1070.avatar_changer.get_description = __S[3]

__S[3] = function(u1111, r1)
    if not r1 then
        r1 = u824.HumanoidRigType.R15
    end

    local function r2(u1112)
        local function r6()
            return u1054:CreateHumanoidModelFromDescriptionAsync(u1111, u1112, u824.AssetTypeVerification.Always)
        end

        local r5, r6_2 = pcall(r6)

        if not r5 or not r6_2 then
            local function r3()
                return u1054:CreateHumanoidModelFromDescriptionAsync(u1111, u1112)
            end

            r5, r6_2 = pcall(r3)
        end

        if not r5 or not r6_2 then
            return nil
        end

        r6_2.Name = "ZenthraAvatarPreview"
        r6_2.Parent = u1057

        pcall(function()
            u1055.Heartbeat:Wait()
        end)

        return r6_2
    end

    local r3 = r2(r1)

    if r3 then
        return r3
    end

    return r2(r1 == u824.HumanoidRigType.R15 and u824.HumanoidRigType.R6 or u824.HumanoidRigType.R15)
end

u1070.avatar_changer.create_temp_model = __S[3]

__S[3] = function(r0)
    local r291 = r0:GetDescendants()

    for r2, r3 in ipairs(r291) do
        if r3:IsA("Weld") or r3:IsA("Motor6D") or r3:IsA("WeldConstraint") then
            r3:Destroy()
        end
    end
end

u1070.avatar_changer.strip_accessory_joints = __S[3]

__S[3] = function(r0, r1)
    if not r1 or r1 == "" then
        return nil
    end

    local r12 = r0:FindFirstChild(r1)

    if r12 and r12:IsA("BasePart") then
        return r12
    end

    local r7 = {
        ["Left Arm"] = {"LeftUpperArm", "LeftLowerArm", "LeftHand"},
        ["Right Arm"] = {"RightUpperArm", "RightLowerArm", "RightHand"},
        ["Left Leg"] = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
        ["Right Leg"] = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        Torso = {"UpperTorso", "LowerTorso"}
    }

    local r4 = r7[r1] or {}

    for r4_2, r5 in ipairs(r4) do
        local r12_2 = r0:FindFirstChild(r5)

        if r12_2 and r12_2:IsA("BasePart") then
            return r12_2
        end
    end

    return nil
end

u1070.avatar_changer.find_body_part = __S[3]

__S[3] = function(r0, u1116, r2)
    if not r0 or not r2 then
        return false
    end

    local u1115 = r2:Clone()
    u1070.avatar_changer.strip_accessory_joints(u1115)
    local r7 = u1115:FindFirstChild("Handle")

    if not r7 or not r7:IsA("BasePart") then
        u1115:Destroy()
        return false
    end

    r7.Anchored = false
    r7.CanCollide = false
    r7.Massless = true
    local r3 = r2:FindFirstChild("Handle")

    if r3 then
        r3 = r3:FindFirstChild("AccessoryWeld")
    end

    local r17 = u819.new()
    local r18 = u819.new()
    local r9

    if r3 and r3:IsA("Weld") and r3.Part1 then
        r9 = u1070.avatar_changer.find_body_part(r0, r3.Part1.Name)
        r17 = r3.C0
        r18 = r3.C1
    end

    local r16

    if not r9 then
        local r2_2 = r7:FindFirstChildOfClass("Attachment")

        if r2_2 then
            local r305 = r0:GetDescendants()

            for r4, r5 in ipairs(r305) do
                if r5:IsA("Attachment") and r5.Name == r2_2.Name and not r5:IsDescendantOf(u1115) then
                    r9 = r5.Parent
                    r17 = r2_2.CFrame
                    r18 = r5.CFrame
                    break
                end
            end

            r16 = r9
        else
            r16 = r9
        end
    else
        r16 = r9
    end

    local r4_2

    if not r16 then
        local r3_2 = u1115.AccessoryType
        local r5_2 = r3_2 == u824.AccessoryType.Hair
        local r2_3

        if r5_2 then
            r2_3 = r5_2
        else
            local r2_4 = u824.AccessoryType.Hat
            r5_2 = r3_2 == r2_4

            if r3_2 ~= r2_4 then
                r2_4 = u824.AccessoryType.Face
                r5_2 = r3_2 == r2_4
            end

            if r3_2 ~= r2_4 then
                r2_4 = u824.AccessoryType.Eyebrow
                r5_2 = r3_2 == r2_4
            end

            if r3_2 == r2_4 then
                r2_3 = r5_2
            else
                r2_3 = r3_2 == u824.AccessoryType.Eyelash
            end
        end

        if r2_3 then
            r16 = r0:FindFirstChild("Head")
        end

        if not r16 then
            r16 = r0:FindFirstChild("Head") or r0:FindFirstChild("UpperTorso") or r0:FindFirstChild("Torso")
        end

        r17 = u819.new(0, 0.5, 0)
        r18 = u819.new()
        r4_2 = r16
    else
        r4_2 = r16
    end

    if r4_2 and r4_2:IsA("BasePart") then
        local r3_3 = u850.new("Weld")
        r3_3.Name = "AccessoryWeld"
        r3_3.Part0 = r7
        r3_3.Part1 = r4_2
        r3_3.C0 = r17
        r3_3.C1 = r18
        r3_3.Parent = r7
        u1115.Parent = r0
        return true
    end

    if u1116 then
        local function r3_4()
            u1116:AddAccessory(u1115)
        end

        if pcall(r3_4) and u1115.Parent == r0 then
            return true
        end
    end

    u1115:Destroy()
    return false
end

u1070.avatar_changer.attach_accessory = __S[3]

__S[3] = function(u1120, u1122)
    local u1117 = {}
    local u1118 = {}
    local r17

    local function u1119(r0)
        if not r0 or u1118[r0] then
            return
        end

        u1118[r0] = true
        table.insert(u1117, r0)
    end

    if u1120 then
        local r3 = u1120:GetChildren()

        for r3_2, r4 in ipairs(r3) do
            if r4:IsA("Accessory") or r4:IsA("Hat") then
                u1119(r4)
            end
        end

        if #u1117 == 0 then
            local r4_2 = u1120
            u1120 = "Humanoid"
            local u1121 = r4_2:FindFirstChildOfClass(u1120)

            if u1121 then
                pcall(function()
                    local r287 = u1121:GetAccessories()

                    for r1, r2 in ipairs(r287) do
                        u1119(r2)
                    end
                end)
            end
        end
    end

    if u1122 and u1122.GetAccessories then
        pcall(function()
            local r1 = u1122:GetAccessories(true)

            for r1_2, r2 in ipairs(r1) do
                local u1123 = r2.AssetId

                if u1123 and 0 < u1123 then
                    pcall(function()
                        local r4 = u796:GetObjects("rbxassetid://" .. u1123)

                        for r1, r2 in ipairs(r4) do
                            local r9 = r2:IsA("Accessory") and r2 or r2:FindFirstChildOfClass("Accessory")

                            if not r9 then
                                local r298 = r2:GetDescendants()

                                for r4_2, r5 in ipairs(r298) do
                                    if r5:IsA("Accessory") then
                                        r9 = r5
                                        break
                                    end
                                end
                            end

                            if r9 then
                                u1119(r9)
                            end
                        end
                    end)
                end
            end
        end)
    end

    if u1122 and #u1117 == 0 then
        for r6, r7 in ipairs({
            "HatAccessory",
            "HairAccessory",
            "FaceAccessory",
            "NeckAccessory",
            "ShouldersAccessory",
            "FrontAccessory",
            "BackAccessory",
            "WaistAccessory"
        }) do
            local r2 = u1122[r7]

            if r2 and r2 ~= "" then
                for r9, r10 in string.gmatch(tostring(r2), "%d+") do
                    local u1125 = tonumber(r9)

                    if u1125 and 0 < u1125 then
                        local function r4_3()
                            local r4 = u796:GetObjects("rbxassetid://" .. u1125)

                            for r1, r2 in ipairs(r4) do
                                local r9 = r2:IsA("Accessory") and r2 or r2:FindFirstChildOfClass("Accessory")

                                if not r9 then
                                    local r298 = r2:GetDescendants()

                                    for r4_2, r5 in ipairs(r298) do
                                        if r5:IsA("Accessory") then
                                            r9 = r5
                                            break
                                        end
                                    end
                                end

                                if r9 then
                                    u1119(r9)
                                end
                            end
                        end

                        u1120 = pcall
                        u1120(r4_3)
                    end
                end
            end
        end
    end

    return u1117
end

u1070.avatar_changer.collect_accessories = __S[3]

__S[3] = function(r0)
    local r290 = r0:GetChildren()

    for r2, r3 in ipairs(r290) do
        if r3:IsA("Accessory") or r3:IsA("Hat") then
            r3:Destroy()
        end
    end
end

u1070.avatar_changer.remove_accessories = __S[3]

__S[3] = function(r0, r1)
    if not r0 or not r1 then
        return false
    end

    local r13 = r1:FindFirstChild("Handle")

    if not r13 or not r13:IsA("BasePart") then
        return false
    end

    r13.Anchored = false
    r13.CanCollide = false
    r13.Massless = true
    local r8 = r13:FindFirstChild("AccessoryWeld")

    if not r8 then
        local r302 = r13:GetChildren()

        for r4, r5 in ipairs(r302) do
            if r5:IsA("Weld") or r5:IsA("WeldConstraint") then
                r8 = r5
                break
            end
        end
    end

    if r8 and r8.Part1 then
        local r13_2 = u1070.avatar_changer.find_body_part(r0, r8.Part1.Name)

        if r13_2 then
            r8.Part1 = r13_2
            r1.Parent = r0
            return true
        end
    end

    return u1070.avatar_changer.attach_accessory(r0, nil, r1)
end

u1070.avatar_changer.transfer_accessory_from_temp = __S[3]

__S[3] = function(u1126, r1, r2, r3)
    u1070.avatar_changer.remove_accessories(u1126)
    local u1127 = 0

    if r2 then
        local r308 = r2:GetChildren()

        for r6, r7 in ipairs(r308) do
            if (r7:IsA("Accessory") or r7:IsA("Hat")) and u1070.avatar_changer.transfer_accessory_from_temp(u1126, r7) then
                u1127 = u1127 + 1
            end
        end

        if u1127 == 0 then
            local u1128 = r2:FindFirstChildOfClass("Humanoid")

            if u1128 then
                pcall(function()
                    local r288 = u1128:GetAccessories()

                    for r1, r2 in ipairs(r288) do
                        if u1070.avatar_changer.transfer_accessory_from_temp(u1126, r2) then
                            u1127 = u1127 + 1
                        end
                    end
                end)
            end
        end
    end

    if u1127 == 0 then
        local r5 = u1070.avatar_changer.collect_accessories(nil, r3)

        for r10, r11 in ipairs(r5) do
            if u1070.avatar_changer.attach_accessory(u1126, r1, r11) then
                u1127 = u1127 + 1
            end
        end
    end

    return u1127
end

u1070.avatar_changer.apply_accessories = __S[3]

__S[3] = function(r0, r1)
    if not r0 or not r1 then
        return
    end

    for r3, r4 in ipairs({
        {"BodyHeightScale", r1.HeightScale, false},
        {"BodyWidthScale", r1.WidthScale, false},
        {"BodyDepthScale", r1.DepthScale, false},
        {"HeadScale", r1.HeadScale, false},
        {"BodyTypeScale", r1.BodyTypeScale, true},
        {"ProportionScale", r1.ProportionScale, true}
    }) do
        local r16 = r4[1]
        local r7 = r4[2]
        local r5 = r4[3]

        if typeof(r7) == "number" and (r7 > 0 or r5 and r7 >= 0) then
            local r5_2 = r0:FindFirstChild(r16)

            if not r5_2 and r0.RigType == u824.HumanoidRigType.R15 then
                local r6 = u850.new("NumberValue")
                r6.Name = r16
                r6.Parent = r0
                r5_2 = r6
            end

            if r5_2 and r5_2:IsA("NumberValue") then
                r5_2.Value = r7
            end
        end
    end
end

u1070.avatar_changer.apply_body_scales = __S[3]

__S[3] = function(u1129, r1)
    if not u1129 or not r1 then
        return
    end

    if r1.Head and (r1.Head == 15093053680 or r1.Head == 134082513) then
        pcall(u1070.avatar.apply_headless, u1129)
    end

    if r1.RightLeg and r1.RightLeg == 139607718 then
        pcall(function()
            if u1129:FindFirstChild("RightLeg") or u1129:FindFirstChild("Right Leg") then
                u1070.avatar.apply_korblox(u1129)
                return
            end

            for r1, r2 in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local r7 = u1129:FindFirstChild(r2)

                if r7 then
                    r7.Transparency = 1
                end
            end

            local r0 = u1129:FindFirstChild("RightUpperLeg")

            if r0 and not r0:FindFirstChild("KorbloxLeg") then
                local r1_2 = u850.new("Part")
                r1_2.Name = "KorbloxLeg"
                r1_2.CanCollide = false
                r1_2.Massless = true
                r1_2.Size = Vector3.new(1, 2, 1)
                local r2_2 = u850.new("SpecialMesh")
                r2_2.MeshId = "rbxassetid://101851696"
                r2_2.TextureId = "rbxassetid://115727863"
                r2_2.Scale = Vector3.new(1, 1, 1)
                r2_2.Parent = r1_2
                local r2_3 = u850.new("Weld")
                r2_3.Part0 = r0
                r2_3.Part1 = r1_2
                r2_3.C0 = u819.new(0, -0.5, 0)
                r2_3.Parent = r1_2
                r1_2.Parent = r0
            end
        end)
    end
end

u1070.avatar_changer.apply_special_body_parts = __S[3]

__S[3] = function(u1130, u1131, r2)
    if not u1130 or not u1131 then
        return
    end

    if r2 and r2.RigType ~= u824.HumanoidRigType.R15 then
        local r327 = u1130:GetChildren()

        for r4, u1132 in ipairs(r327) do
            if u1132:IsA("CharacterMesh") then
                pcall(function()
                    local r290 = u1131:GetChildren()

                    for r1, r2 in ipairs(r290) do
                        if r2:IsA("CharacterMesh") and r2.BodyPart == u1132.BodyPart then
                            r2:Destroy()
                        end
                    end

                    u1132:Clone().Parent = u1131
                end)
            end
        end

        return
    end

    for r7, r8 in ipairs({
        "Head",
        "UpperTorso",
        "LowerTorso",
        "LeftUpperArm",
        "LeftLowerArm",
        "LeftHand",
        "RightUpperArm",
        "RightLowerArm",
        "RightHand",
        "LeftUpperLeg",
        "LeftLowerLeg",
        "LeftFoot",
        "RightUpperLeg",
        "RightLowerLeg",
        "RightFoot"
    }) do
        local u1133 = u1130:FindFirstChild(r8)
        local u1134 = u1131:FindFirstChild(r8)

        if u1133 and u1134 and u1133:IsA("MeshPart") and u1134:IsA("MeshPart") then
            local u1135 = false

            pcall(function()
                u1134:ApplyMesh(u1133)
                u1135 = true
            end)

            if not u1135 then
                pcall(function()
                    u1134.MeshId = u1133.MeshId
                end)

                pcall(function()
                    u1134.TextureID = u1133.TextureID
                end)
            end

            pcall(function()
                local r4 = u1134:FindFirstChildOfClass("SurfaceAppearance")

                if r4 then
                    r4:Destroy()
                end

                local r0 = u1133:FindFirstChildOfClass("SurfaceAppearance")

                if r0 then
                    r0:Clone().Parent = u1134
                end
            end)
        end
    end
end

u1070.avatar_changer.transfer_body_meshes = __S[3]

__S[3] = function(r0, r1, u1136, u1137)
    if not r0 or not r1 or not u1136 then
        return false
    end

    pcall(function()
        if u1136.ApplyDescriptionClientServer then
            u1136:ApplyDescriptionClientServer(u1137)
        else
            u1136:ApplyDescription(u1137)
        end
    end)

    u1070.avatar_changer.transfer_body_meshes(r0, r1, u1136)

    for r5, r6 in ipairs({"Shirt", "Pants", "ShirtGraphic"}) do
        local r15 = r0:FindFirstChildOfClass(r6)

        if r15 then
            local r7 = r1:FindFirstChildOfClass(r6)

            if r7 then
                r7:Destroy()
            end

            r15:Clone().Parent = r1
        end
    end

    local r15_2 = r0:FindFirstChildOfClass("BodyColors")
    local r6_2 = r1:FindFirstChildOfClass("BodyColors")

    if not r6_2 then
        r6_2 = u850.new("BodyColors")
        r6_2.Parent = r1
    end

    if r15_2 then
        r6_2.HeadColor3 = r15_2.HeadColor3
        r6_2.TorsoColor3 = r15_2.TorsoColor3
        r6_2.LeftArmColor3 = r15_2.LeftArmColor3
        r6_2.RightArmColor3 = r15_2.RightArmColor3
        r6_2.LeftLegColor3 = r15_2.LeftLegColor3
        r6_2.RightLegColor3 = r15_2.RightLegColor3
    end

    if u1137 then
        r6_2.HeadColor3 = u1137.HeadColor
        r6_2.TorsoColor3 = u1137.TorsoColor
        r6_2.LeftArmColor3 = u1137.LeftArmColor
        r6_2.RightArmColor3 = u1137.RightArmColor
        r6_2.LeftLegColor3 = u1137.LeftLegColor
        r6_2.RightLegColor3 = u1137.RightLegColor
    end

    local r14 = r0:FindFirstChild("Head")
    local r5_2 = r1:FindFirstChild("Head")

    if r14 and r5_2 then
        local r11 = r14:FindFirstChild("face") or r14:FindFirstChildOfClass("Decal")

        if r11 then
            local r6_3 = r5_2:FindFirstChild("face") or r5_2:FindFirstChildOfClass("Decal")

            if r6_3 then
                r6_3:Destroy()
            end

            local r4 = r11:Clone()
            r4.Name = "face"
            r4.Parent = r5_2
        end
    end

    u1070.avatar_changer.apply_body_scales(u1136, u1137)
    u1070.avatar_changer.apply_special_body_parts(r1, u1137)
    u1070.avatar_changer.apply_accessories(r1, u1136, r0, u1137)
    return true
end

u1070.avatar_changer.transfer_appearance = __S[3]

__S[3] = function(r0)
    local r15 = {}
    local r325 = r0:GetChildren()

    for r3, r4 in ipairs(r325) do
        if r4:IsA("Tool") or r4:IsA("HopperBin") then
            table.insert(r15, r4)
            r4.Parent = nil
        end
    end

    local r3_2 = r0.Parent and r0.Parent:FindFirstChild("Backpack")

    if r3_2 then
        local r327 = r3_2:GetChildren()

        for r6, r7 in ipairs(r327) do
            if r7:IsA("Tool") or r7:IsA("HopperBin") then
                table.insert(r15, r7)
            end
        end
    end

    local r4_2 = {}
    local r323 = r0:GetDescendants()

    for r9, r10 in ipairs(r323) do
        if r10:IsA("BaseScript") then
            r4_2[r10] = true

            if r10.Parent then
                r4_2[r10.Parent] = true
            end
        end
    end

    local r321 = r0:GetChildren()

    for r12, r13 in ipairs(r321) do
        if not r4_2[r13] and (r13:IsA("Accessory") or r13:IsA("Hat") or r13:IsA("BodyColors") or r13:IsA("CharacterMesh") or r13:IsA("Shirt") or r13:IsA("Pants") or r13:IsA("ShirtGraphic")) then
            r13:Destroy()
        end
    end

    for r15_2, r16 in ipairs(r15) do
        if r16 and r16.Parent == nil then
            if r3_2 then
                r16.Parent = r3_2
            end

            if not r3_2 then
                r16.Parent = r0
            end
        end
    end
end

u1070.avatar_changer.clean = __S[3]

__S[3] = function(r0, u1138, r2)
    if not r0 or not u1138 then
        return
    end

    if not r2 then
        local r5 = u1070.avatar_changer.original_parts or {}
        u1070.avatar_changer.original_parts = r5

        if not u1070.avatar_changer.original_parts[r0.Name] then
            local r7 = r0:Clone()
            local r319 = r7:GetChildren()

            for r4, r5_2 in ipairs(r319) do
                if r5_2:IsA("JointInstance") then
                    r5_2:Destroy()
                end
            end

            u1070.avatar_changer.original_parts[r0.Name] = r7
        end
    end

    u1138.Name = r0.Name
    u1138.CFrame = r0.CFrame
    u1138.Color = r0.Color
    u1138.Transparency = r0.Transparency
    u1138.CanCollide = r0.CanCollide
    u1138.Anchored = r0.Anchored
    local r315 = r0:GetChildren()

    for r8, u1139 in ipairs(r315) do
        if u1139:IsA("Attachment") and not u1138:FindFirstChild(u1139.Name) then
            pcall(function()
                u1139:Clone().Parent = u1138
            end)
        end
    end

    local r4_2 = {}
    local r14 = r0.Parent

    if r14 then
        local r317 = r14:GetDescendants()

        for r11, r12 in ipairs(r317) do
            if r12:IsA("Motor6D") and (r12.Part0 == r0 or r12.Part1 == r0) then
                table.insert(r4_2, {
                    class = r12.ClassName,
                    name = r12.Name,
                    parent = r12.Parent == r0 and "new" or r12.Parent,
                    part0 = r12.Part0 == r0 and "new" or r12.Part0,
                    part1 = r12.Part1 == r0 and "new" or r12.Part1,
                    c0 = r12.C0,
                    c1 = r12.C1,
                    joint_obj = r12
                })
            end
        end
    end

    u1138.Parent = r0.Parent

    for r14_2, u1140 in ipairs(r4_2) do
        local u1141 = u1140.joint_obj
        local r4_3 = u1140.part0 == "new" and u1138 or u1140.part0
        local r5_3 = u1140.part1 == "new" and u1138 or u1140.part1
        local r6 = u1140.parent == "new" and u1138 or u1140.parent

        pcall(function()
            u1141:Destroy()
        end)

        local u1142 = r4_3
        local u1143 = r5_3
        local u1144 = r6

        pcall(function()
            local r0 = u850.new("Motor6D")
            r0.Name = u1140.name
            r0.Part0 = u1142
            r0.Part1 = u1143
            r0.C0 = u1140.c0
            r0.C1 = u1140.c1
            r0.Parent = u1144
        end)
    end

    r0:Destroy()
end

u1070.avatar_changer.replace_body_part = __S[3]

__S[3] = function(u1145)
    if not u1145 then
        return
    end

    pcall(u1070.avatar.remove_headless, u1145)
    pcall(u1070.avatar.remove_korblox, u1145)

    pcall(function()
        for r1, r2 in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
            local r3 = u1145:FindFirstChild(r2)

            if r3 then
                r3.Transparency = 0
            end
        end

        local r0 = u1145:FindFirstChild("RightUpperLeg")

        if r0 then
            r0 = r0:FindFirstChild("KorbloxLeg")
        end

        if r0 then
            r0:Destroy()
        end
    end)

    if not u1070.avatar_changer.original_parts then
        return
    end

    for r4, u1146 in pairs(u1070.avatar_changer.original_parts) do
        local u1147 = u1145:FindFirstChild(r4)

        if u1147 then
            pcall(function()
                u1070.avatar_changer.replace_body_part(u1147, u1146:Clone(), true)
            end)
        end
    end

    u1070.avatar_changer.original_parts = nil
end

u1070.avatar_changer.revert_to_original = __S[3]

__S[3] = function(u1148, r1, u1149)
    if u1070.avatar_changer.applying then
        return
    end

    u1070.avatar_changer.applying = true

    pcall(function()
        u1070.avatar_changer.expected_accessories = #u1148:GetAccessories(true)
    end)

    task.spawn(function()
        local function u1150()
            local function r6()
                if u1149 then
                    return false
                end

                return not u1070.avatar_changer.enabled
            end

            local r7 = u1061.Character or u1061.CharacterAdded:Wait()

            if r6() then
                u1070.avatar_changer.applying = false
                return
            end

            if not r7 then
                u1070.avatar_changer.applying = false
                return
            end

            r7 = u1061.Character or r7
            local u1151 = r7:FindFirstChildOfClass("Humanoid") or r7:WaitForChild("Humanoid", 5)

            if not u1151 then
                u1070.avatar_changer.applying = false
                return
            end

            if not u1149 then
                u1070.avatar_changer.revert_to_original(r7)
            end

            u1070.avatar_changer.clean(r7)

            if r6() then
                u1070.avatar_changer.applying = false
                return
            end

            local r6_2 = u1070.avatar_changer.create_temp_model(u1148, u1151.RigType)
            local r9 = false

            if r6_2 then
                r9 = u1070.avatar_changer.transfer_appearance(r6_2, r7, u1151, u1148)
                r6_2:Destroy()
            end

            if r9 then
                return
            end

            pcall(function()
                if u1151.ApplyDescriptionClientServer then
                    u1151:ApplyDescriptionClientServer(u1148)
                else
                    u1151:ApplyDescription(u1148)
                end
            end)

            u1070.avatar_changer.apply_body_scales(u1151, u1148)
            u1070.avatar_changer.apply_special_body_parts(r7, u1148)
            local r2 = r7:FindFirstChildOfClass("BodyColors")

            if not r2 then
                r2 = u850.new("BodyColors")
                r2.Parent = r7
            end

            r2.HeadColor3 = u1148.HeadColor
            r2.TorsoColor3 = u1148.TorsoColor
            r2.LeftArmColor3 = u1148.LeftArmColor
            r2.RightArmColor3 = u1148.RightArmColor
            r2.LeftLegColor3 = u1148.LeftLegColor
            r2.RightLegColor3 = u1148.RightLegColor
            u1070.avatar_changer.apply_accessories(r7, u1151, nil, u1148)
        end

        pcall(u1150)
        u1150 = u1070.avatar_changer
        u1150.applying = false
    end)
end

u1070.avatar_changer.apply_description = __S[3]

__S[3] = function(u1153)
    if u1070.avatar_changer.applying then
        return
    end

    u1070.avatar_changer.attempt_id = (u1070.avatar_changer.attempt_id or 0) + 1
    local u1152 = u1070.avatar_changer.attempt_id

    task.spawn(function()
        if not u1070.avatar_changer.enabled or u1070.avatar_changer.target ~= u1153 or u1070.avatar_changer.attempt_id ~= u1152 then
            return
        end

        local r0 = u1077(u1153)

        if not r0 then
            return
        end

        if u1070.avatar_changer.applied_id == r0 then
            return
        end

        local r1 = u1070.avatar_changer.get_description(r0)

        if not r1 then
            return
        end

        if not u1070.avatar_changer.enabled or u1070.avatar_changer.target ~= u1153 or u1070.avatar_changer.attempt_id ~= u1152 then
            return
        end

        u1070.avatar_changer.applied_id = r0
        u1070.avatar_changer.apply_description(r1, r0)
    end)
end

u1070.avatar_changer.apply = __S[3]

__S[3] = function()
    if not u1070.avatar_changer.original_desc then
        return
    end

    u1070.avatar_changer.applied_id = nil
    u1070.avatar_changer.applying = false
    local r0 = u1061.Character

    if r0 then
        u1070.avatar_changer.revert_to_original(r0)
    end

    u1070.avatar_changer.apply_description(u1070.avatar_changer.original_desc, u1061.UserId, true)
end

u1070.avatar_changer.restore = __S[3]

local function u1154(r0, r1)
    u1070.avatar_changer.applying = false
    u1070.avatar_changer.applied_id = nil
    u1070.avatar_changer.apply(r0)
    local r2 = 0

    while not u1070.avatar_changer.applying and r2 < 2 do
        task.wait(0.05)
        r2 = r2 + 0.05
    end

    local r2_2 = 0

    while u1070.avatar_changer.applying do
        if not (r2_2 < (r1 or 8)) then
            break
        end

        task.wait(0.05)
        r2_2 = r2_2 + 0.05
    end
end

function u1070.avatar_changer.reapply_on_spawn(u1155)
    if not (u1070.avatar_changer.enabled and u1070.avatar_changer.target ~= "") then
        return
    end

    if not u1155 then
        return
    end

    u1070.avatar_changer.respawn_token = (u1070.avatar_changer.respawn_token or 0) + 1
    local u1156 = u1070.avatar_changer.respawn_token

    task.spawn(function()
        if not (u1155:FindFirstChildOfClass("Humanoid") or u1155:WaitForChild("Humanoid", 10)) then
            return
        end

        u1155:WaitForChild("HumanoidRootPart", 10)
        local u1157 = false

        pcall(function()
            u1157 = u1061:HasAppearanceLoaded()
        end)

        if not u1157 then
            local u1158 = false

            local r1 = u1061.CharacterAppearanceLoaded:Connect(function()
                u1158 = true
            end)

            local r3 = 0

            while not u1158 and r3 < 6 do
                task.wait(0.1)
                r3 = r3 + 0.1

                pcall(function()
                    if u1061:HasAppearanceLoaded() then
                        u1158 = true
                    end
                end)
            end

            if r1 then
                r1:Disconnect()
            end
        end

        if u1070.avatar_changer.respawn_token ~= u1156 then
            return
        end

        for r1_2 = 1, 3 do
            if u1070.avatar_changer.respawn_token ~= u1156 then
                return
            end

            if not (u1070.avatar_changer.enabled and u1070.avatar_changer.target ~= "") then
                return
            end

            if u1155.Parent == nil then
                return
            end

            u1154(u1070.avatar_changer.target, 8)

            if r1_2 < 3 then
                task.wait(1)
            end
        end
    end)
end

u1061.CharacterAdded:Connect(function(r0)
    u1070.avatar_changer.reapply_on_spawn(r0)
end)

__S[3] = function(r0)
    local r4 = r0:FindFirstChild("RightLeg") or r0:FindFirstChild("Right Leg")

    if not r4 then
        return
    end

    local r296 = r4:GetChildren()

    for r2, r3 in ipairs(r296) do
        if r3:IsA("SpecialMesh") or r3:IsA("Mesh") then
            r3:Destroy()
        end
    end

    local r1 = u850.new("SpecialMesh")
    r1.MeshId = "rbxassetid://101851696"
    r1.TextureId = "rbxassetid://115727863"
    r1.Scale = Vector3.new(1, 1, 1)
    r1.Parent = r4
end

u1070.avatar.apply_korblox = __S[3]

__S[3] = function(r0)
    local r1 = r0:FindFirstChild("RightLeg") or r0:FindFirstChild("Right Leg")

    if not r1 then
        return
    end

    local r293 = r1:GetChildren()

    for r2, r3 in ipairs(r293) do
        if r3:IsA("SpecialMesh") and r3.MeshId == "rbxassetid://101851696" then
            r3:Destroy()
        end
    end
end

u1070.avatar.remove_korblox = __S[3]

__S[3] = function(r0)
    u1070.avatar.korblox_enabled = r0

    if u1070.avatar.korblox_conn then
        u1070.avatar.korblox_conn:Disconnect()
        u1070.avatar.korblox_conn = nil
    end

    local r2 = u1061.Character

    if r0 then
        if r2 then
            u1070.avatar.apply_korblox(r2)
        end

        local function r0_2(r0)
            task.wait(0.1)

            if u1070.avatar.korblox_enabled then
                u1070.avatar.apply_korblox(r0)
            end
        end

        u1070.avatar.korblox_conn = u1061.CharacterAdded:Connect(r0_2)
    elseif r2 then
        u1070.avatar.remove_korblox(r2)
    end
end

u1070.avatar.set_korblox = __S[3]

__S[3] = function(r0)
    local r1 = r0:FindFirstChild("Head")

    if not r1 then
        return
    end

    r1.Transparency = 1
    local r1_2 = r1:FindFirstChildOfClass("Decal")

    if r1_2 then
        r1_2:Destroy()
    end
end

u1070.avatar.apply_headless = __S[3]

__S[3] = function(r0)
    local r2 = r0:FindFirstChild("Head")

    if not r2 then
        return
    end

    r2.Transparency = 0
end

u1070.avatar.remove_headless = __S[3]

__S[3] = function(r0)
    u1070.avatar.headless_enabled = r0

    if u1070.avatar.headless_conn then
        u1070.avatar.headless_conn:Disconnect()
        u1070.avatar.headless_conn = nil
    end

    local r2 = u1061.Character

    if r0 then
        if r2 then
            u1070.avatar.apply_headless(r2)
        end

        local function r0_2(r0)
            task.wait(0.1)

            if u1070.avatar.headless_enabled then
                u1070.avatar.apply_headless(r0)
            end
        end

        u1070.avatar.headless_conn = u1061.CharacterAdded:Connect(r0_2)
    else
        if r2 then
            u1070.avatar.remove_headless(r2)
        end
    end
end

u1070.avatar.set_headless = __S[3]

__S[3] = function(r0)
    return 0.5 + (math.clamp(r0 or u1070.config.accuracy, 1, 100) - 1) * 0.010101010101010102
end

u1070.parry.get_divisor_multiplier = __S[3]

__S[3] = function(r0, r1)
    return math.clamp(u1070.cache.get_ping() / 10 / 10, 5, 17) + math.max(r0 / ((2.4 + math.min(math.max(r0 - 9.5, 0), 650) * 0.002) * u1070.parry.get_divisor_multiplier(r1)), 9.5)
end

u1070.parry.get_premium_parry_distance = __S[3]

__S[3] = function()
    local r0 = u1070.parry_cooldown
    r0.pending_id = r0.pending_id + 1
    local u1159 = r0.pending_id

    task.delay(r0.success_window, function()
        if u1070.parry_cooldown.pending_id == u1159 then
            u1070.parry_cooldown.failed_at = u817()
        end
    end)
end

u1070.parry.mark_attempt = __S[3]

__S[3] = function(u1160)
    if u1070.parry_cooldown.conn then
        u1070.parry_cooldown.conn:Disconnect()
        u1070.parry_cooldown.conn = nil
    end

    if not u1160 then
        return
    end

    u1070.parry_cooldown.last_parrying = u1160:GetAttribute("Parrying")
    u1070.parry_cooldown.failed_at = 0

    u1070.parry_cooldown.conn = u1160:GetAttributeChangedSignal("Parrying"):Connect(function()
        local r0 = u1160:GetAttribute("Parrying")

        if u1070.parry_cooldown.last_parrying == true and r0 == false then
            u1070.parry_cooldown.failed_at = u817()
        elseif r0 == nil or r0 == true then
            u1070.parry_cooldown.failed_at = 0
        end

        u1070.parry_cooldown.last_parrying = r0
    end)
end

u1070.parry.hook_cooldown_tracker = __S[3]

if u1061.Character then
    u808(u1070.parry.hook_cooldown_tracker, u1061.Character)
end

u1061.CharacterAdded:Connect(function(r0)
    pcall(u1070.parry.hook_cooldown_tracker, r0)
end)

__S[3] = function()
    local r291 = u1070.ball.get_all()
    local r4 = 0

    for r1, r2 in ipairs(r291) do
        r4 = math.max(r4, u1070.ball.get_velocity(r2.part, r2.model).Magnitude)
    end

    return math.clamp(u1070.parry.get_premium_parry_distance(r4, u1070.config.accuracy), 4, 60)
end

u1070.parry_visualizer.get_parry_radius = __S[3]

__S[3] = function()
    local r4 = u1070.parry_visualizer

    if r4.sphere and r4.sphere.Parent then
        r4.sphere:Destroy()
    end

    r4.sphere = nil
    r4.weld = nil
    local r5 = u1070.player.get_root()

    if not r5 then
        return
    end

    local r6 = u850.new("Part")
    r6.Name = "ParryVisualizerSphere"
    r6.Shape = u824.PartType.Ball
    r6.Material = u824.Material.ForceField
    r6.Color = r4.color
    r6.Size = Vector3.new(8, 8, 8)
    r6.Anchored = true
    r6.CanCollide = false
    r6.CanTouch = false
    r6.CanQuery = false
    r6.CastShadow = false
    r6.Transparency = 0.35
    r6.CFrame = r5.CFrame
    r6.Parent = u1058
    r4.sphere = r6
end

u1070.parry_visualizer.rebuild_sphere = __S[3]

__S[3] = function(u1163)
    local u1161 = u1070.parry_hits
    local r9 = u1161.color

    while #u1161.parts >= 20 do
        local r5 = table.remove(u1161.parts, 1)

        if r5 and r5.Parent then
            r5:Destroy()
        end
    end

    local u1162 = {}

    for r2 = 1, 12 do
        local r3 = r2 <= 4
        local r1 = r3 and math.random(70, 110) / 100 or math.random(25, 55) / 100
        local r12 = u850.new("Part")
        r12.Size = Vector3.new(0.1, r1, 0.1)
        r12.Anchored = true
        r12.CanCollide = false
        r12.CanTouch = false
        r12.CanQuery = false
        r12.CastShadow = false
        r12.Material = u824.Material.Neon
        r12.Color = r9
        r12.CFrame = u819.new(u1163)
        r12.Parent = u1058

        if r2 == 1 then
            local r4 = u850.new("PointLight")
            r4.Brightness = 5
            r4.Range = 12
            r4.Color = r9
            r4.Parent = r12
        end

        r2 = r2 / 12 * 3.141592653589793 * 2 + math.random() * 0.5
        local r7 = r3 and 3.141592653589793 * 0.35 + math.random() * 3.141592653589793 * 0.3 or math.random() * 3.141592653589793

        table.insert(u1162, {
            part = r12,
            dir = Vector3.new(math.sin(r7) * math.cos(r2), math.abs(math.cos(r7)) * 0.5 + math.random() * 0.6, math.sin(r7) * math.sin(r2)).Unit,
            speed = r3 and math.random(6, 10) or math.random(3, 6),
            init_len = r1,
            rx = (math.random() - 0.5) * 0.25,
            ry = (math.random() - 0.5) * 0.25,
            rz = (math.random() - 0.5) * 0.25
        })

        table.insert(u1161.parts, r12)
    end

    task.spawn(function()
        local r8 = 0

        while r8 < 1.4 do
            r8 = r8 + u1063:Wait()
            local r9 = r8 / 1.4

            for r1, r2 in ipairs(u1162) do
                if r2.part.Parent then
                    r2.part.CFrame = u819.new(u1163 + r2.dir * (r2.speed * (1 - (1 - r9) ^ 3) * 3.5)) * u819.Angles(r2.rx * r8 * 6, r2.ry * r8 * 6, r2.rz * r8 * 6)
                    local r3 = math.max(1 - r9, 0)
                    r2.part.Size = Vector3.new(0.1, r2.init_len * r3, 0.1)
                    r2.part.Transparency = math.clamp((r9 - 0.3) / 0.7, 0, 1)
                    local r3_2 = r2.part:FindFirstChildOfClass("PointLight")

                    if r3_2 then
                        r3_2.Brightness = 5 * (1 - r9) ^ 2
                    end
                end
            end
        end

        for r4, r5 in ipairs(u1162) do
            if r5.part.Parent then
                local r6 = table.find(u1161.parts, r5.part)

                if r6 then
                    table.remove(u1161.parts, r6)
                end

                r5.part:Destroy()
            end
        end
    end)
end

u1070.parry_hits.spawn = __S[3]

__S[3] = function()
    u1070.parry_hits.active = true
end

u1070.parry_hits.start = __S[3]

__S[3] = function()
    u1070.parry_hits.active = false

    for r1, r2 in ipairs(u1070.parry_hits.parts) do
        if r2 and r2.Parent then
            r2:Destroy()
        end
    end

    u1070.parry_hits.parts = {}
end

u1070.parry_hits.stop = __S[3]

__S[3] = function(r0)
    u1070.parry_hits.color = r0
end

u1070.parry_hits.update_color = __S[3]

__S[3] = function()
    if u1070.parry_visualizer.active then
        return
    end

    u1070.parry_visualizer.active = true
    u1070.parry_visualizer.rebuild_sphere()

    u1070.parry_visualizer.char_conn = u1061.CharacterAdded:Connect(function()
        task.wait(0.5)

        if u1070.parry_visualizer.active then
            u1070.parry_visualizer.rebuild_sphere()
        end
    end)

    local function r3()
    end

    u1070.parry_visualizer.connection = u1063:Connect(r3)
end

u1070.parry_visualizer.start = __S[3]

__S[3] = function()
    if not u1070.parry_visualizer.active then
        return
    end

    u1070.parry_visualizer.active = false

    if u1070.parry_visualizer.connection then
        u1070.parry_visualizer.connection:Disconnect()
        u1070.parry_visualizer.connection = nil
    end

    if u1070.parry_visualizer.char_conn then
        u1070.parry_visualizer.char_conn:Disconnect()
        u1070.parry_visualizer.char_conn = nil
    end

    if u1070.parry_visualizer.sphere and u1070.parry_visualizer.sphere.Parent then
        u1070.parry_visualizer.sphere:Destroy()
    end

    u1070.parry_visualizer.sphere = nil
    u1070.parry_visualizer.weld = nil

    for r2, r3 in ipairs(u1070.parry_visualizer.parts) do
        if r3 and r3.Parent then
            r3:Destroy()
        end
    end

    u1070.parry_visualizer.parts = {}
end

u1070.parry_visualizer.stop = __S[3]

__S[3] = function(r0)
    u1070.parry_visualizer.color = r0

    if u1070.parry_visualizer.sphere and u1070.parry_visualizer.sphere.Parent then
        u1070.parry_visualizer.sphere.Color = r0
    end
end

u1070.parry_visualizer.update_color = __S[3]

local function u1164(u1165)
    if not u1165 or u1165 == "" then
        return nil
    end

    local function r5()
        return require(u1057.Shared.Abilities[u1165])
    end

    local r4, r5_2 = pcall(r5)
    return r4 and r5_2 or nil
end

local function u1166(u1168, u1167)
    if not u1167 or u1167 == "" then
        return 0
    end

    local function r3()
        return u1168.Upgrades[u1167].Value
    end

    local r2, r3_2 = pcall(r3)
    return r2 and r3_2 or 0
end

local function u1169(r0)
    return 2 + u1166(r0, "Dribble")
end

local function u1170(r0, r1)
    if not r0 or r0 == "" then
        return nil
    end

    return r0 .. " V" .. u1166(r1, r0) + 1
end

local function u1171()
    local function r1()
        return tonumber(u1061.PlayerGui.Hotbar.Ability.ready.counts.Text)
    end

    local u1172 = pcall
    local r1_2
    u1172, r1_2 = u1172(r1)
    u1172 = u1172 and r1_2 or nil
    return u1172
end

__S[3] = function()
    local r4 = Drawing.new("Text")
    r4.Visible = false
    r4.Center = true
    r4.Outline = true
    r4.OutlineColor = u820.new(0, 0, 0)
    r4.Color = u1070.ability_esp.cd_color
    r4.Size = u1070.ability_esp.cd_size
    r4.Font = Drawing.Fonts.UI
    return r4
end

u1070.ability_esp.new_cd_drawing = __S[3]

__S[3] = function(r0)
    r0.nameDraw.Visible = false
    r0.abilityDraw.Visible = false
    r0.timerDraw.Visible = false
    r0.cdDraw.Visible = false
    r0.usesDraw.Visible = false

    for r3, r4 in ipairs(r0.cdDrawings) do
        r4.Visible = false
    end

    if r0.billboard then
        r0.billboard.Enabled = false
        r0.billboard.Adornee = nil
    end
end

u1070.ability_esp.hide_all = __S[3]

__S[3] = function(r0, r1)
    if not r0.billboard or not r0.billboard.Parent then
        if not u1070.ability_esp._holder or not u1070.ability_esp._holder.Parent then
            u1070.ability_esp._holder = u858()
        end

        local r8 = u850.new("BillboardGui")
        r8.AlwaysOnTop = true
        r8.Enabled = false
        r8.Parent = u1070.ability_esp._holder
        local r9 = u850.new("ImageLabel")
        r9.Size = u821.new(1, 0, 1, 0)
        r9.BackgroundTransparency = 1
        r9.Image = ""
        r9.Parent = r8
        local r6 = u850.new("TextLabel")
        r6.BackgroundTransparency = 1
        r6.TextStrokeTransparency = 0
        r6.TextStrokeColor3 = u820.new(0, 0, 0)
        r6.Font = u824.Font.GothamBold
        r6.Parent = r8
        r0.billboard = r8
        r0.billboardImg = r9
        r0.billboardLvl = r6
    end

    local r7 = u1070.ability_esp
    local r4 = r7.ability_size * 3
    r0.billboard.Size = u821.new(0, r4, 0, r4)
    r0.billboard.StudsOffset = Vector3.new(0, 4, 0)

    if r0.billboardLvl then
        local r8_2 = r7.ability_size
        r0.billboardLvl.Size = u821.new(0, r8_2 * 2, 0, r8_2 + 4)
        r0.billboardLvl.Position = u821.new(1, -r8_2, 0, 0)
        r0.billboardLvl.TextSize = r8_2
        r0.billboardLvl.TextColor3 = r7.ability_color
    end

    r0.billboard.Adornee = r1
    return r0.billboard, r0.billboardImg, r0.billboardLvl
end

u1070.ability_esp.get_billboard = __S[3]

__S[3] = function(r0)
    if u1070.ability_esp.drawings[r0] then
        u1070.ability_esp.remove_drawing(r0)
    end

    local r3 = u1070.ability_esp

    local function r2(r0, r1)
        local r6 = Drawing.new("Text")
        r6.Visible = false
        r6.Center = true
        r6.Outline = true
        r6.OutlineColor = u820.new(0, 0, 0)
        r6.Color = r1
        r6.Size = r0
        r6.Font = Drawing.Fonts.UI
        return r6
    end

    r3.drawings[r0] = {
        nameDraw = r2(r3.name_size, r3.name_color),
        abilityDraw = r2(r3.ability_size, r3.ability_color),
        timerDraw = r2(r3.active_size, r3.active_color),
        cdDraw = r2(r3.cd_size, r3.cd_color),
        usesDraw = r2(r3.active_size, u820.fromRGB(100, 255, 150)),
        cdQueue = {},
        cdDrawings = {},
        curUses = nil,
        maxUses = nil,
        activeStart = nil,
        activeDur = nil,
        cdStart = nil,
        cdLen = nil,
        abilityName = nil,
        abilityLine = nil,
        iconId = nil,
        billboard = nil,
        billboardImg = nil,
        billboardLvl = nil,
        charConns = {}
    }
end

u1070.ability_esp.create_drawing = __S[3]

__S[3] = function(r0)
    local r2 = u1070.ability_esp.drawings[r0]

    if not r2 then
        return
    end

    r2.nameDraw:Remove()
    r2.abilityDraw:Remove()
    r2.timerDraw:Remove()
    r2.cdDraw:Remove()
    r2.usesDraw:Remove()

    for r5, r6 in ipairs(r2.cdDrawings) do
        r6:Remove()
    end

    if r2.billboard then
        r2.billboard:Destroy()
    end

    local r8 = r2.charConns or {}

    for r8_2, u1173 in ipairs(r8) do
        pcall(function()
            u1173:Disconnect()
        end)
    end

    u1070.ability_esp.drawings[r0] = nil
end

u1070.ability_esp.remove_drawing = __S[3]

__S[3] = function(r0, r1)
    local r3 = u1164(r0.abilityName)

    if not r3 then
        return
    end

    local r1_2 = u1166(r1, r0.abilityName)
    local r1_3 = math.max(0, r3.cooldown - (r3.cooldownReductionPerUpgrade or 0) * r1_2)

    if r1_3 > 0 then
        r0.cdStart = u817()
        r0.cdLen = r1_3
    end
end

u1070.ability_esp.begin_cd = __S[3]

__S[3] = function(u1174)
    u1070.ability_esp.create_drawing(u1174)

    local function u1175(u1177)
        local r8 = u1070.ability_esp.drawings[u1174]

        if not r8 then
            return
        end

        for r3, u1176 in ipairs(r8.charConns) do
            pcall(function()
                u1176:Disconnect()
            end)
        end

        table.clear(r8.charConns)
        r8.activeStart = nil
        r8.activeDur = nil
        r8.cdStart = nil
        r8.cdLen = nil
        r8.cdQueue = {}
        r8.curUses = nil
        r8.maxUses = nil

        for r6, r7 in ipairs(r8.cdDrawings) do
            r7.Visible = false
        end

        if r8.billboard then
            r8.billboard.Adornee = nil
            r8.billboard.Enabled = false
        end

        local r9 = u1174:GetAttribute("CurrentlyEquippedAbility")

        if r9 and r9 ~= "" then
            r8.abilityName = r9
            r8.abilityLine = u1170(r9, u1174)
            local r2 = u1164(r9)

            if r2 then
                r2 = r2.iconId
            end

            r8.iconId = r2 or nil

            if r9 == "Dribble" then
                r8.maxUses = u1169(u1174)
                r8.curUses = r8.maxUses
            end
        end

        table.insert(r8.charConns, u1177.AttributeChanged:Connect(function(r0)
            local r3 = u1070.ability_esp.drawings[u1174]

            if not r3 then
                return
            end

            if r0 == "DribbleDebounce" and u1177:GetAttribute("DribbleDebounce") == true and r3.abilityName == "Dribble" then
                local r2 = u1164("Dribble")

                if r2 then
                    table.insert(r3.cdQueue, {t = u817(), dur = r2.cooldown})
                end

                if r3.curUses ~= nil then
                    r3.curUses = math.max(0, r3.curUses - 1)
                end
            end

            if r0 == "AbilityUpgrade" and u1177:GetAttribute("AbilityUpgrade") ~= nil and r3.abilityName ~= "Dribble" then
                r3.abilityLine = u1170(r3.abilityName, u1174)
                u1070.ability_esp.begin_cd(r3, u1174)
            end

            if r0 ~= "AbilityActive" then
                return
            end

            local r9 = u1177:GetAttribute("AbilityActive")
            local r10 = u1174:GetAttribute("AbilityDuration")

            if r9 == true and r10 and r10 > 0 then
                r3.activeStart = u817()
                r3.activeDur = r10
            else
                r3.activeStart = nil
                r3.activeDur = nil
            end
        end))

        table.insert(r8.charConns, u1174.AttributeChanged:Connect(function(r0)
            local r5 = u1070.ability_esp.drawings[u1174]

            if not r5 then
                return
            end

            if r0 == "CurrentlyEquippedAbility" then
                local r8 = u1174:GetAttribute("CurrentlyEquippedAbility")
                r5.abilityName = r8
                r5.abilityLine = u1170(r8, u1174)
                r5.cdStart = nil
                r5.cdLen = nil
                r5.cdQueue = {}

                for r3, r4 in ipairs(r5.cdDrawings) do
                    r4.Visible = false
                end

                local r2 = u1164(r8)

                if r2 then
                    r2 = r2.iconId
                end

                r5.iconId = r2 or nil

                if r8 == "Dribble" then
                    r5.maxUses = u1169(u1174)
                    r5.curUses = r5.maxUses
                else
                    r5.maxUses = nil
                    r5.curUses = nil
                end
            end

            if r0 ~= "AbilityDuration" then
                return
            end

            local r6 = u1177:GetAttribute("AbilityActive")
            local r7 = u1174:GetAttribute("AbilityDuration")

            if r6 == true and r7 and r7 > 0 then
                r5.activeStart = u817()
                r5.activeDur = r7
            end
        end))
    end

    if u1174.Character then
        u1175(u1174.Character)
    end

    u1174.CharacterAdded:Connect(function(r0)
        u1175(r0)
    end)

    u1174.CharacterRemoving:Connect(function()
        local r0 = u1070.ability_esp.drawings[u1174]

        if not r0 then
            return
        end

        u1070.ability_esp.hide_all(r0)
        r0.activeStart = nil
        r0.activeDur = nil
        r0.cdStart = nil
        r0.cdLen = nil
        r0.cdQueue = {}
        r0.curUses = nil
        r0.maxUses = nil
    end)
end

u1070.ability_esp.track_player = __S[3]

__S[6] = function()
    local v1 = u817()
    local v2 = u1070.ability_esp

    for v3, v4 in u811(v2.drawings) do
        if not v3 or not v3.Parent then
            v2.remove_drawing(v3)
            continue
        end

        local v5 = v3.Character
        local v6 = v5 and (v5:FindFirstChild("HumanoidRootPart"))

        if not v6 then
            v2.hide_all(v4)
            continue
        end

        local v7, v8 = u1062:WorldToViewportPoint(v6.Position + u818.new(0, 3.5, 0))

        if not v8 or v7.Z < 0 then
            v2.hide_all(v4)
            continue
        end

        v5, v8 = Vector2.new(v7.X, v7.Y), 0

        if v2.show_name then
            v7 = v2.name_mode == "Username" and v3.Name or v3.DisplayName
            v4.nameDraw.Position = v5 + Vector2.new(0, -(v2.name_size - 9))
            v4.nameDraw.Text = v7
            v4.nameDraw.Size = v2.name_size
            v4.nameDraw.Color = v2.name_color
            v4.nameDraw.Visible = true
        else
            v4.nameDraw.Visible = false
        end

        if v2.mode == "Image" then
            v4.abilityDraw.Visible = false

            if v4.iconId and v4.iconId ~= "" and v4.iconId ~= "rbxassetid://0" then
                local v9, v10, v11 = v2.get_billboard(v4, v6)
                v10.Image = v4.iconId

                if v11 then
                    v11.Text = "V" .. u1166(v3, v4.abilityName) + 1
                end

                v9.Enabled = true
            elseif v4.billboard then
                v4.billboard.Enabled = false
            end

            local v12, v13, v14 = v2.ability_size * 3, u1062:WorldToViewportPoint(v6.Position + u818.new(0, 3.5 + (v4.billboard and v4.billboard.StudsOffset.Y or 4), 0))

            if v14 and v13.Z > 0 then
                u1062:WorldToViewportPoint(v6.Position + u818.new(0, 3.5 + (v4.billboard and v4.billboard.StudsOffset.Y or 4), 0))
                v8 += v12 * (v12 / u827.max(1, u1062.ViewportSize.Y / 10)) * 0.5 + 4
            else
                v8 += v2.ability_size + 4
            end
        else
            if v4.billboard then
                v4.billboard.Enabled = false
            end

            if v4.abilityLine then
                v4.abilityDraw.Position = v5 + Vector2.new(0, v8)
                v4.abilityDraw.Text = v4.abilityLine
                v4.abilityDraw.Size = v2.ability_size
                v4.abilityDraw.Color = v2.ability_color
                v4.abilityDraw.Visible = true
                v8 += v2.ability_size + 4
            else
                v4.abilityDraw.Visible = false
            end
        end

        if v4.abilityName == "Dribble" then
            v4.cdDraw.Visible = false
            local v15 = v4.maxUses or (u1169(v3))
            v7 = v3 == u1061 and (u1171()) or v4.curUses

            if v2.show_cd and v7 ~= nil then
                local v16 = v7 / u827.max(1, v15)
                v4.usesDraw.Color = u820.fromRGB(u827.floor(255 * (1 - v16)), u827.floor(255 * v16), 50)
                v4.usesDraw.Size = v2.active_size
                v4.usesDraw.Position = v5 + Vector2.new(0, v8)
                v4.usesDraw.Text = "uses  " .. v7
                v4.usesDraw.Visible = true
                v8 += v2.active_size + 2
            else
                v4.usesDraw.Visible = false
            end

            local v17 = 1

            while v17 <= #v4.cdQueue do
                v6 = v4.cdQueue[v17]

                if v1 - v6.t >= v6.dur then
                    if v3 ~= u1061 and v4.curUses ~= nil then
                        v4.curUses = u827.min(v15, v4.curUses + 1)
                    end

                    u825.remove(v4.cdQueue, v17)
                else
                    v17 += 1
                end
            end

            while #v4.cdDrawings < #v4.cdQueue do
                u825.insert(v4.cdDrawings, v2.new_cd_drawing())
            end

            if v2.show_cd then
                for v18, v19 in u812(v4.cdQueue) do
                    v17, v15 = u827.max(0, v19.dur - (v1 - v19.t)), v4.cdDrawings[v18]
                    v15.Size = v2.cd_size
                    v15.Color = v2.cd_color
                    v15.Position = v5 + Vector2.new(0, v8)
                    v15.Text = u826.format("cd %d  %.1fs", v18, v17)
                    v15.Visible = true
                    v8 += v2.cd_size + 2
                end

                for v20 = #v4.cdQueue + 1, #v4.cdDrawings do
                    v4.cdDrawings[v20].Visible = false
                end
            else
                for v21, v22 in u812(v4.cdDrawings) do
                    v22.Visible = false
                end
            end
        else
            v4.usesDraw.Visible = false

            for v23, v24 in u812(v4.cdDrawings) do
                v24.Visible = false
            end

            if v2.show_cd and v4.cdStart and v4.cdLen then
                local v25 = u827.max(0, v4.cdLen - (v1 - v4.cdStart))

                if v25 > 0 then
                    v4.cdDraw.Size = v2.cd_size
                    v4.cdDraw.Color = v2.cd_color
                    v4.cdDraw.Position = v5 + Vector2.new(0, v8)
                    v4.cdDraw.Text = u826.format("cd  %.1fs", v25)
                    v4.cdDraw.Visible = true
                    v8 += v2.cd_size + 2
                else
                    v4.cdDraw.Visible = false
                    v4.cdStart = nil
                    v4.cdLen = nil
                end
            else
                v4.cdDraw.Visible = false

                if v4.cdStart and v4.cdLen then
                    if v4.cdLen - (v1 - v4.cdStart) <= 0 then
                        v4.cdStart = nil
                        v4.cdLen = nil
                    end
                end
            end
        end

        if v2.show_timer and v4.activeStart and v4.activeDur then
            v3 = u827.max(0, v4.activeDur - (v1 - v4.activeStart))

            if v3 > 0 then
                v4.timerDraw.Size = v2.active_size
                v4.timerDraw.Color = v2.active_color
                v4.timerDraw.Position = v5 + Vector2.new(0, v8)
                v4.timerDraw.Text = u826.format("active  %.1fs", v3)
                v4.timerDraw.Visible = true
            else
                v4.timerDraw.Visible = false
                v4.activeStart = nil
                v4.activeDur = nil
            end
        else
            v4.timerDraw.Visible = false

            if v4.activeStart and v4.activeDur then
                if v4.activeDur - (v1 - v4.activeStart) <= 0 then
                    v4.activeStart = nil
                    v4.activeDur = nil
                end
            end
        end
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.ability_esp.update = __S[6]

__S[3] = function()
    if u1070.ability_esp.active then
        return
    end

    u1070.ability_esp.active = true

    pcall(function()
        require(u1057.Shared.Abilities)
    end)

    local r1 = u1054:GetPlayers()

    for r1_2, r2 in ipairs(r1) do
        if r2 ~= u1061 then
            u1070.ability_esp.track_player(r2)
        end
    end

    u1054.PlayerAdded:Connect(function(r0)
        if u1070.ability_esp.active and r0 ~= u1061 then
            u1070.ability_esp.track_player(r0)
        end
    end)

    u1054.PlayerRemoving:Connect(function(r0)
        u1070.ability_esp.remove_drawing(r0)
    end)

    u1070.ability_esp.connection = u1064:Connect(u1070.ability_esp.update)
end

u1070.ability_esp.start = __S[3]

__S[3] = function()
    if not u1070.ability_esp.active then
        return
    end

    u1070.ability_esp.active = false

    if u1070.ability_esp.connection then
        u1070.ability_esp.connection:Disconnect()
        u1070.ability_esp.connection = nil
    end

    for r1, r2 in pairs(u1070.ability_esp.drawings) do
        u1070.ability_esp.remove_drawing(r1)
    end
end

u1070.ability_esp.stop = __S[3]

__S[6] = function(v1, v2, v3, v4, v5, v6)
    if not v3 then
        local v7 = u1061.Character
        local v8 = v7 and v7.PrimaryPart

        if not v8 then
            return false, false
        end

        v3 = v8.Position
    end

    if not v4 then
        local v9 = v1:FindFirstChild("zoomies")

        if not v9 then
            return false, false
        end

        v4 = v9.VectorVelocity
        v5 = v4.Magnitude
    end

    v5 = v5 or v4.Magnitude

    if v5 < 1 then
        return false, false
    end

    local v10 = v1.Position
    v6 = v6 or (v3 - v10).Magnitude
    local v11 = 1 / v5
    local v12, v13 = v4 * v11, (v3 - v10).Unit
    v3 = v13:Dot(v12)
    local v14 = v3 < 0
    v10 = u1070.cache.get_ping()
    local v15 = v10 * 0.001
    local v16, v17, v18, v19, v20 = u827.min(v5 * 0.01, 40), v3 > 0 and 40 * v3 or 0, v3 - v13:Dot((v12 - v4).Unit), 0.5 - v15, (v6 * v11 - v15) / 1.5
    local v21, v22 = 15 - u827.min(v6 * 0.001, 15) + v17 + v16, u1070.curve_detection
    v17 = v22.per_ball[v1]

    if not v17 then
        v17 = {vel = {}, last_warping = 0, lerp = 0}
        v22.per_ball[v1] = v17
    end

    v1 = v17.vel
    v16 = #v1

    if v16 >= 4 then
        v1[1], v1[2], v1[3] = v1[2], v1[3], v1[4]
        v1[4] = v4
        v16 = 4
    else
        v16 += 1
        v1[v16] = v4
    end

    if v6 < (if v5 > 100 and v6 * v11 - v15 > v10 * 0.1 then (u827.max(v21 - 15, 15)) else v21) then
        return false, v14
    end

    v5 = u817()

    if v5 - (v22.curve_time or 0) < v20 then
        return true, v14
    end

    if v18 < v19 then
        return true, v14
    end

    v18 = u827.rad(u827.asin(u827.clamp(v3, -1, 1)))
    v17.lerp = v17.lerp + (v18 - v17.lerp) * 0.8

    if v17.lerp < 0.018 then
        v17.last_warping = v5
    end

    if v5 - v17.last_warping < v20 then
        return true, v14
    end

    if v16 == 4 then
        if v3 - v13:Dot((v12 - v1[1].Unit).Unit) < v19 then
            return true, v14
        end

        if v3 - v13:Dot((v12 - v1[2].Unit).Unit) < v19 then
            return true, v14
        end
    end

    return v3 < v19, v14
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.ball.is_curved = __S[6]
local u1178

local function u1179()
    if u1178 then
        return true
    end

    local r4 = u1057:FindFirstChild("Controllers")

    if not r4 then
        return false
    end

    local r292 = r4:GetChildren()

    for r1, r2 in ipairs(r292) do
        if r2.Name:find("SwordsController", 1, true) == 1 then
            local r7 = r2:FindFirstChild("PRY")

            if r7 then
                local r5, r6 = pcall(require, r7)

                if r5 and type(r6) == "function" then
                    u1178 = require(u1057.Packages.Signal).new()
                    u1178:Connect(r6)
                    return true
                end
            end
        end
    end

    return false
end

__S[6] = function()
    if u1068 then
        return false
    end

    if not u1179() then
        return false
    end

    local r1 = u1178.Fire
    local r2 = u1178
    local r4 = u1070.curve.get_cframe()
    local r5 = u1070.parry.get_event_data()
    local r6 = u1070.parry.get_mouse_vec()
    return pcall(r1, r2, 0.5, r4, r5, r6, false)
end

u1070.parry.fire_remote = __S[6]

u1061.CharacterAdded:Connect(function()
    u1070.state.grab_track = nil
end)

__S[3] = function()
    local r1 = u1061.Character

    if not r1 then
        return nil
    end

    local r4 = u1070.sword_changer.enabled

    if r4 then
        r4 = u1070.sword_changer.animations ~= "" and u1070.sword_changer.animations or r1:GetAttribute("CurrentlyEquippedSword")
    elseif not r4 then
        r4 = r1:GetAttribute("CurrentlyEquippedSword")
    end

    if not r4 then
        r4 = u1061:GetAttribute("CurrentlyEquippedSword")
    end

    return r4
end

u1070.animation.get_sword_name = __S[3]

__S[3] = function()
    local u1180 = u1070.animation.get_sword_name()
    local r4 = u1057.Shared.SwordAPI.Collection

    if u1180 then
        local function r0()
            return u1057.Shared.ReplicatedInstances.Swords.GetSword:Invoke(u1180)
        end

        local r2, r3 = pcall(r0)
        local r5 = r3

        if r2 and r5 and r5.AnimationType then
            local r0_2 = r4:FindFirstChild(r5.AnimationType)

            if r0_2 then
                return r0_2
            end
        end
    end

    return r4.Default
end

u1070.animation.get_anim_folder = __S[3]

__S[3] = function(r0, r1)
    if not r0 then
        return
    end

    local r300 = r0:GetPlayingAnimationTracks()

    for r3, u1181 in ipairs(r300) do
        for r6, r7 in ipairs(r1) do
            if u1181:GetAttribute(r7) then
                pcall(function()
                    u1181:Stop(u1181:GetAttribute("StopFadeTime"))
                end)

                break
            end
        end
    end
end

u1070.animation.stop_tracks_with_attrs = __S[3]

__S[3] = function()
    local r4 = u1061.Character

    if not r4 then
        return
    end

    local r5 = r4:FindFirstChildOfClass("Humanoid")
    local r10 = r5 and r5:FindFirstChildOfClass("Animator")

    if not r10 then
        return
    end

    if r4:GetAttribute("InOverdriveMech") then
        return
    end

    u1070.animation.stop_tracks_with_attrs(r10, {"SuccessParry", "Parry", "GrabParry"})
    local r1 = u1070.animation.get_anim_folder()

    if not r1 then
        return
    end

    local r11 = r1:FindFirstChild("GrabParry") or r1:FindFirstChild("Grab") or r1:FindFirstChild("Parry")

    if not r11 then
        return
    end

    local r13 = r10:LoadAnimation(r11)
    r13.Priority = u824.AnimationPriority.Action4
    r13:Play(r13:GetAttribute("PlayFadeTime"), r13:GetAttribute("PlayWeight"), r13:GetAttribute("PlaySpeed"))
    local r8 = r13:GetAttribute("PlaySpeed") or 1
    r4:SetAttribute("ParryTime", math.max(r4:GetAttribute("ParryTime") or 0, r13.Length == 0 and 1 or (r13.Length - r13.TimePosition) * r8))
    u1070.state.grab_track = r13
end

u1070.animation.play_grab = __S[3]

__S[3] = function()
    local u1182 = u1070.state.grab_track

    if u1182 then
        pcall(function()
            u1182:Stop(u1182:GetAttribute("StopFadeTime"))
        end)
    end

    u1070.state.grab_track = nil
    local r5 = u1061.Character

    if r5 then
        r5 = r5:FindFirstChildOfClass("Humanoid")
    end

    local r7 = r5 and r5:FindFirstChildOfClass("Animator")

    if not r7 then
        return
    end

    u1070.animation.stop_tracks_with_attrs(r7, {"GrabParry", "Parry"})
end

u1070.animation.stop_grab = __S[3]

__S[3] = function()
    local function u1183()
        local r1 = u1057.Remotes.ParrySuccess.OnClientEvent
        local u1184 = r1.Connect

        u1184(r1, function()
            local r0 = u1070.parry_cooldown
            r0.pending_id = r0.pending_id + 1
            u1070.parry_cooldown.failed_at = 0
            u1070.animation.stop_grab()

            if u1070.parry_hits.active then
                local r0_2 = u1070.player.get_root()

                if r0_2 then
                    u1070.parry_hits.spawn(r0_2.Position)
                end
            end

            if u1070.config.auto_parry and u1070.state.parried then
                local u1185 = task.delay

                u1185(0.15, function()
                    local r4 = u797:FindFirstChild("Alive")
                    local r9

                    if r4 then
                        local r8 = false
                        local r292 = r4:GetChildren()
                        r9 = true

                        for r1, r2 in ipairs(r292) do
                            if r2.Name == u1061.Name then
                                r9 = true
                            else
                                local r7 = u1054:FindFirstChild(r2.Name)

                                if not r7 then
                                    r9 = false
                                    r8 = true
                                    break
                                end

                                if r7:GetAttribute("CurrentlyEquippedAbility") ~= "Invisibility" then
                                    r8 = true
                                    r9 = false
                                    break
                                end

                                r8 = true

                                if not r2:GetAttribute("AbilityActive") then
                                    r9 = false
                                    r8 = true
                                    break
                                end

                                r9 = true
                            end
                        end

                        if not r8 then
                            r9 = false
                        end
                    else
                        r9 = false
                    end

                    if r9 and #u1070.ball.get_targeted() > 0 then
                        u1070.state.parried = false
                    end
                end)
            end
        end)
    end

    pcall(u1183)
end

u1070.animation.init = __S[3]

__S[3] = function(r0)
    local r3 = r0:FindFirstChild("CollisionWhitelist")

    if not r3 then
        return false
    end

    return r3.Value == u1061.Character
end

u1070.ball.is_model_targeting_me = __S[3]

__S[6] = function()
    local v1 = {}
    local v2 = {"Balls", "TrainingBalls"}

    for v3, v4 in u812(v2) do
        v3 = u797:FindFirstChild(v4)

        if not v3 then
            continue
        end

        for v5, v6 in u812(v3:GetChildren()) do
            if v6:GetAttribute("realBall") then
                u825.insert(v1, {part = v6, model = nil})
                continue
            end

            if v6:IsA("Model") then
                v5 = v6:FindFirstChild("Corpo") or v6.PrimaryPart or (v6:FindFirstChildWhichIsA("BasePart"))

                if v5 then
                    u825.insert(v1, {part = v5, model = v6})
                end
            end
        end
    end

    return v1
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.ball.get_all = __S[6]

__S[6] = function()
    local v1 = u1061.Name
    local v2 = {}

    for v3, v4 in u812(u1070.ball.get_all()) do
        if if v4.model then (u1070.ball.is_model_targeting_me(v4.model)) else v4.part:GetAttribute("target") == v1 then
            u825.insert(v2, v4)
        end
    end

    return v2
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.ball.get_targeted = __S[6]

__S[6] = function(v1, v2)
    if v2 then
        local v3 = v2:GetAttribute("Velocity")

        if u810(v3) == "Vector3" then
            return v3
        end
    end

    v2 = v1:FindFirstChild("zoomies")

    if v2 then
        return v2.VectorVelocity
    end

    return v1.AssemblyLinearVelocity
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.ball.get_velocity = __S[6]

__S[3] = function()
    local r5 = u797:FindFirstChild("Balls")

    if not r5 then
        return nil
    end

    local r292 = r5:GetChildren()

    for r2, r3 in ipairs(r292) do
        if r3:IsA("BasePart") then
            return r3
        end
    end

    return nil
end

u1070.ball.get_first = __S[3]

__S[6] = function(v1, v2)
    local v3 = u814(v1)
    local v4 = u1070.curve_detection

    if not u1070.state.ball_tracking[v3] then
        u1070.state.ball_tracking[v3] = {samples = {}}
    end

    if not v4.velocity_history[v3] then
        v4.velocity_history[v3] = {}
    end

    if not v4.dot_histories[v3] then
        v4.dot_histories[v3] = {}
    end

    local v5 = u1070.ball.get_velocity(v1, v2)
    local v6 = u1070.player.get_root()
    local v7 = u1070.state.ball_tracking[v3].samples
    u825.insert(v7, {vel = v5, t = u1066()})

    if #v7 > 20 then
        u825.remove(v7, 1)
    end

    v7 = v4.velocity_history[v3]
    u825.insert(v7, v5)

    if #v7 > 10 then
        u825.remove(v7, 1)
    end

    if v6 then
        v7, v2 = v4.dot_histories[v3], (v6.Position - v1.Position).Unit:Dot(v5.Unit)
        u825.insert(v7, v2)

        if #v7 > 10 then
            u825.remove(v7, 1)
        end
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.ball.update_tracking = __S[6]

__S[3] = function(u1186)
    if u1186:FindFirstChild("AeroDynamicSlashVFX") then
        pcall(function()
            u1186.AeroDynamicSlashVFX:Destroy()
        end)

        u1070.detections.tornado_time = u817()
    end

    if u1067 and u1067:FindFirstChild("Tornado") then
        local r3 = u1067.Tornado:GetAttribute("TornadoTime") or 1

        if u817() - u1070.detections.tornado_time < r3 + 0.314159 then
            return true
        end
    end

    return false
end

u1070.ball.check_tornado = __S[3]

__S[6] = function()
    local v1 = u1061.Character
    return v1 and (v1:FindFirstChild("HumanoidRootPart"))
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.player.get_root = __S[6]

__S[3] = function()
    local r4 = u1061.Character

    if not r4 then
        return false
    end

    local r3 = r4:FindFirstChildOfClass("Humanoid")
    local r0 = r4:FindFirstChild("HumanoidRootPart")
    local r1 = r3 ~= nil

    if r3 ~= nil then
        r1 = r0 ~= nil

        if r0 ~= nil then
            r1 = r3.Health > 0
        end
    end

    return r1
end

u1070.player.is_alive = __S[3]

__S[3] = function()
    local r1 = u1061.Character

    if not r1 or not r1.PrimaryPart then
        return false
    end

    return r1.PrimaryPart:FindFirstChild("SingularityCape") ~= nil
end

u1070.player.has_singularity_cape = __S[3]

__S[3] = function()
    local r4 = u797:FindFirstChild("Alive")

    if r4 then
        return r4:GetChildren()
    end

    local r4_2 = {}
    local r289 = u1054:GetPlayers()

    for r1, r2 in ipairs(r289) do
        if r2.Character then
            table.insert(r4_2, r2.Character)
        end
    end

    return r4_2
end

u1070.player.get_alive_chars = __S[3]

__S[3] = function()
    if not u1070.player.get_root() then
        return nil
    end

    local function r6()
        return u1056:GetMouseLocation()
    end

    local r5, r6_2 = pcall(r6)

    if not r5 then
        return nil
    end

    local r0 = u1062:ScreenPointToRay(r6_2.X, r6_2.Y)
    local r8 = u819.lookAt(r0.Origin, r0.Origin + r0.Direction)
    local r9 = -(1/0)
    local r295 = u1070.player.get_alive_chars()
    local r10

    for r1, r2 in ipairs(r295) do
        if not (r2 == u1061.Character) then
            local r3 = r2:FindFirstChild("HumanoidRootPart")

            if r3 then
                local r4 = r8.LookVector:Dot((r3.Position - u1062.CFrame.Position).Unit)

                if r9 < r4 then
                    r9 = r4
                    r10 = r2
                end
            end
        end
    end

    return r10
end

u1070.player.get_closest_to_cursor = __S[3]

__S[3] = function()
    if u1070.config.target_player_enabled and u1070.config.target_player_name then
        local r0 = u1054:FindFirstChild(u1070.config.target_player_name)

        if r0 and r0.Character then
            local r1 = r0.Character:FindFirstChild("HumanoidRootPart")

            if r1 then
                return r1.Position
            end
        end
    end

    local r2 = u1070.player.get_closest_to_cursor()

    if r2 then
        local r1_2 = r2:FindFirstChild("HumanoidRootPart")

        if r1_2 then
            return r1_2.Position
        end
    end

    local r0_2 = u1070.player.get_root()

    if r0_2 then
        r0_2 = r0_2.Position + u1062.CFrame.LookVector * 100
    end

    return r0_2
end

u1070.curve.get_target_pos = __S[3]

__S[3] = function()
    local r12 = u1070.player.get_root()

    if not r12 then
        return u1062.CFrame
    end

    local r13 = u1070.curve.get_target_pos() or r12.Position + u1062.CFrame.LookVector * 100
    local r7 = u1062.CFrame.RightVector
    local r1 = Vector3.new(0, 1, 0)
    local r14 = -(r13 - r12.Position).Unit
    local r15 = u1070.config.curve_mode
    local r0 = math.random

    if r15 == 1 then
        return u1062.CFrame
    elseif r15 == 2 then
        local r17 = r0(0, 1) == 0 and -1 or 1

        local r8 = {
            r14 * r0(7000, 12000) + r7 * (r17 * r0(2000, 5000)) + r1 * r0(3000, 6000),
            r14 * r0(8000, 15000) + r7 * (r17 * r0(1500, 4000)) + r1 * r0(2000, 5000),
            r7 * (r17 * r0(8000, 15000)) + r14 * r0(2000, 5000) + r1 * r0(2000, 5000),
            r7 * (r17 * r0(10000, 18000)) + r14 * r0(1000, 3000) + r1 * r0(1500, 4000),
            r14 * r0(10000, 18000) + r7 * (r17 * r0(3000, 6000)) + r1 * r0(2500, 5500),
            r1 * r0(6000, 10000) + r14 * r0(4000, 8000) + r7 * (r17 * r0(2000, 5000))
        }

        return u819.new(r12.Position, r13 + r8[r0(1, #r8)])
    elseif r15 == 3 then
        return u819.new(r12.Position, r13 + Vector3.new(0, 5, 0))
    elseif r15 == 4 then
        return u819.new(u1062.CFrame.Position, r12.Position + (r12.Position - r13).Unit * 10000 + Vector3.new(0, 1000, 0))
    elseif r15 == 5 then
        return u819.new(r12.Position, r13 + Vector3.new(0, -9e+18, 0))
    elseif r15 == 6 then
        return u819.new(r12.Position, r13 + Vector3.new(0, 9e+18, 0))
    elseif r15 == 7 then
        local r2 = math.clamp(((r12.Position - r13).Magnitude - 60) * 0.2, -25, 5)
        local r0_2 = r13 + Vector3.new(0, r2, 0)
        return u819.new(r12.Position, r0_2)
    end

    return u1062.CFrame
end

u1070.curve.get_cframe = __S[3]

__S[3] = function()
    local r6 = {}

    if u1070.config.target_player_enabled and u1070.config.target_player_name then
        local u1187 = u1054:FindFirstChild(u1070.config.target_player_name)

        if u1187 and u1187.Character and u1187.Character.PrimaryPart then
            local function r5()
                return u1062:WorldToScreenPoint(u1187.Character.PrimaryPart.Position)
            end

            local r4, r5_2 = pcall(r5)

            if r4 then
                r6[u1187.Character.Name] = r5_2
            end
        end

        return r6
    end

    local r291 = u1070.player.get_alive_chars()

    for r1, u1188 in ipairs(r291) do
        if u1188.PrimaryPart then
            local function r5_3()
                return u1062:WorldToScreenPoint(u1188.PrimaryPart.Position)
            end

            local r4_2, r5_4 = pcall(r5_3)

            if r4_2 then
                r6[u1188.Name] = r5_4
            end
        end
    end

    return r6
end

u1070.parry.get_event_data = __S[3]

__S[3] = function()
    if u1070.config.is_mobile then
        local r0 = u1062.ViewportSize
        return {r0.X / 2, r0.Y / 2}
    end

    if u1070.config.target_player_enabled and u1070.config.target_player_name then
        local r0_2 = u1054:FindFirstChild(u1070.config.target_player_name)

        if r0_2 and r0_2.Character then
            local u1189 = r0_2.Character:FindFirstChild("HumanoidRootPart")

            if u1189 then
                local function r3()
                    return u1062:WorldToScreenPoint(u1189.Position)
                end

                local r2, r3_2 = pcall(r3)

                if r2 then
                    return {r3_2.X, r3_2.Y}
                end
            end
        end
    end

    local r2_2 = u1070.player.get_closest_to_cursor()

    if r2_2 then
        local u1190 = r2_2:FindFirstChild("HumanoidRootPart")

        if u1190 then
            local function r3_3()
                return u1062:WorldToScreenPoint(u1190.Position)
            end

            local r2_3, r3_4 = pcall(r3_3)

            if r2_3 then
                return {r3_4.X, r3_4.Y}
            end
        end
    end

    local function r2_4()
        return u1056:GetMouseLocation()
    end

    local r1, r2_5 = pcall(r2_4)

    if r1 then
        r1 = {r2_5.X, r2_5.Y}
    end

    if not r1 then
        r1 = {0, 0}
    end

    return r1
end

u1070.parry.get_mouse_vec = __S[3]

__S[3] = function()
    if u1070.config.parry_mode == "Keypress" then
        u1076()
        task.spawn(u1070.animation.play_grab)
        return
    end

    if not u1070.parry.fire_remote() then
        u1076()
    end

    task.spawn(u1070.animation.play_grab)
end

u1070.parry.execute = __S[3]

__S[6] = function(v1)
    if v1 == "Keypress" then
        u1075()
        return
    end

    if not u1070.parry.fire_remote() then
        u1075()
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.parry.execute_fast = __S[6]

__S[3] = function(r0, r1)
    local r2 = u1070.player.get_root()

    if not r2 then
        return false
    end

    local r6 = u1070.ball.get_velocity(r0, r1).Magnitude
    return (r2.Position - r0.Position).Magnitude <= u1070.parry.get_premium_parry_distance(r6, u1070.config.accuracy)
end

u1070.parry.should_fire = __S[3]

__S[3] = function()
    if not u1070.ability.cooldown_protection then
        return false
    end

    local r0 = u1070.parry_cooldown.failed_at

    if r0 == 0 then
        return false
    end

    if u817() - r0 >= u1070.parry_cooldown.duration then
        u1070.parry_cooldown.failed_at = 0
        return false
    end

    local r0_2 = pcall(function()
        u1057.Remotes.AbilityButtonPress:Fire()
    end)

    u1070.parry_cooldown.failed_at = 0
    return r0_2
end

u1070.parry.try_cooldown_protection = __S[3]

__S[3] = function()
    local u1191 = u1070.ability.auto_ability

    if not u1191 then
        return false
    end

    local function r1()
        if u1061.PlayerGui.Hotbar.Ability.UIGradient.Offset.Y ~= 0.5 then
            return false
        end

        local r9 = u1061.Character and u1061.Character:FindFirstChild("Abilities")

        if not r9 then
            return false
        end

        for r1, r2 in ipairs({
            "Raging Deflection",
            "Rapture",
            "Calming Deflection",
            "Aerodynamic Slash",
            "Fracture",
            "Death Slash"
        }) do
            local r6 = r9:FindFirstChild(r2)

            if r6 and r6.Enabled then
                u1057.Remotes.AbilityButtonPress:Fire()

                if r2 == "Death Slash" then
                    local u1192 = task.delay

                    u1192(2.432, function()
                        pcall(function()
                            u1057:WaitForChild("Remotes"):WaitForChild("DeathSlashShootActivation"):FireServer(true)
                        end)
                    end)
                end

                return true
            end
        end

        return false
    end

    u1191 = pcall
    local r1_2
    u1191, r1_2 = u1191(r1)
    return u1191 and r1_2
end

u1070.parry.try_auto_ability = __S[3]

__S[6] = function()
    local v1 = u1070.config

    if not v1.auto_parry then
        return
    end

    if u1070.triggerbot.enabled then
        return
    end

    if u1070.phantom.active then
        return
    end

    local v2 = u1061.Character

    if not v2 then
        return
    end

    local v3 = v2:FindFirstChild("HumanoidRootPart")

    if not v3 then
        return
    end

    local v4 = v2:FindFirstChildOfClass("Humanoid")

    if not v4 or v4.Health <= 0 then
        return
    end

    if v2.PrimaryPart and (v2.PrimaryPart:FindFirstChild("SingularityCape")) then
        return
    end

    v2 = u1070.ball.get_targeted()

    if #v2 == 0 then
        return
    end

    local v5 = v3.Position
    local v6 = u1070.state
    local v7 = u1070.detections

    for v8, v9 in u812(v2) do
        v8, v4 = v9.part, v9.model

        if v4 then
            (v4:FindFirstChild("CollisionWhitelist") or v4).Changed:Once(function()
                v6.parried = false
            end)
        else
            v8:GetAttributeChangedSignal("target"):Once(function()
                v6.parried = false
            end)
        end

        if v6.parried then
            continue
        end

        if v8:FindFirstChild("ComboCounter") then
            continue
        end

        if u1070.ball.check_tornado(v8) then
            continue
        end

        if v7.infinity and v6.infinity_active then
            continue
        end

        if v7.deathslash and v6.deathslash_active then
            continue
        end

        if v7.slashesoffury and v6.slashesoffury_active then
            continue
        end

        if v7.timehole and v6.timehole_active then
            continue
        end

        v3 = u1070.ball.get_velocity(v8, v4)
        local v10, v11 = v3.Magnitude, (v8.Position - v5).Magnitude
        u1070.ball.update_tracking(v8, v4)

        if v10 >= 40 then
            local v12, v13 = u1070.ball.is_curved(v8, v4, v5, v3, v10, v11)

            if v12 then
                continue
            end

            if v13 then
                continue
            end
        end

        if v11 > u1070.parry.get_premium_parry_distance(v10, v1.accuracy) then
            continue
        end

        if v1.randomize_accuracy then
            v8, v10 = u827.clamp(u827.floor(u827.min(v1.random_accuracy_min, v1.random_accuracy_max)), 1, 100), u827.clamp(u827.floor(u827.max(v1.random_accuracy_min, v1.random_accuracy_max)), 1, 100)
            v1.accuracy = u827.random(v8, v10)
        end

        if u1070.parry.try_cooldown_protection() then
            continue
        end

        if not u1070.parry.try_auto_ability() then
            u1070.parry.execute()
        end

        u1070.parry.mark_attempt()
        v6.parried = true
        u1070.spam.parries += 1

        u828.delay(0.5, function()
            if u1070.spam.parries > 0 then
                u1070.spam.parries -= 1
            end
        end)

        local v14 = u817()

        u828.spawn(function()
            repeat
                u1065:Wait()
            until u817() - v14 >= 1 or not v6.parried

            v6.parried = false
        end)
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.parry.process = __S[6]

__S[6] = function()
    if not u1070.triggerbot.enabled then
        return
    end

    if u1070.player.has_singularity_cape() then
        return
    end

    if u1070.triggerbot.is_parrying then
        return
    end

    local v1 = u797:FindFirstChild("Balls")

    if not v1 then
        return
    end

    for v2, v3 in u812(v1:GetChildren()) do
        if not v3:IsA("BasePart") then
            continue
        end

        if v3:GetAttribute("target") ~= u1061.Name then
            continue
        end

        u1070.triggerbot.is_parrying = true
        u828.spawn(u1070.animation.play_grab)
        u1070.parry.execute()

        v3:GetAttributeChangedSignal("target"):Once(function()
            u1070.triggerbot.is_parrying = false
        end)

        local v4 = u817()

        u828.spawn(function()
            repeat
                u1063:Wait()
            until u817() - v4 >= 1 or not u1070.triggerbot.is_parrying

            u1070.triggerbot.is_parrying = false
        end)

        break
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.triggerbot.process = __S[6]

__S[3] = function(r0)
    u1070.triggerbot.enabled = r0

    if r0 then
        if not u1070.triggerbot.connection then
            u1070.triggerbot.connection = u1063:Connect(u1070.triggerbot.process)
        end
    else
        if u1070.triggerbot.connection then
            u1070.triggerbot.connection:Disconnect()
            u1070.triggerbot.connection = nil
        end

        u1070.triggerbot.is_parrying = false
    end
end

u1070.triggerbot.set = __S[3]

__S[3] = function()
    if u1070.spam.connection_manual then
        u1070.spam.connection_manual:Disconnect()
    end

    u1070.spam.manual_enabled = true

    local function r2()
        if not u1070.spam.manual_enabled then
            return
        end

        local v1 = u1061.Character

        if not v1 then
            return
        end

        local v2 = v1:FindFirstChildOfClass("Humanoid")

        if not v2 or v2.Health <= 0 then
            return
        end

        if not v1:FindFirstChild("HumanoidRootPart") then
            return
        end

        local v3 = u1070.spam.alive_ref

        if not v3 or v3.Parent ~= u797 then
            v3 = u797:FindFirstChild("Alive")
            u1070.spam.alive_ref = v3
        end

        if not v3 or not v3:FindFirstChild(u1061.Name) then
            return
        end

        v3 = u1070.spam.manual_mode

        if v3 == "Remote" and u1070.spam.animation_fix_manual then
            u1075()
        end

        u1070.parry.execute_fast(v3)
    end --[[ LPH_NO_VIRTUALIZE ]]

    u1070.spam.connection_manual = u1065:Connect(r2)
end

u1070.spam.manual_start = __S[3]

__S[3] = function()
    u1070.spam.manual_enabled = false

    if not u1070.spam.connection_manual then
        return
    end

    u1070.spam.connection_manual:Disconnect()

    u1070.spam.connection_manual = nil
end

u1070.spam.manual_stop = __S[3]

__S[3] = function()
    if u1070.spam.connection_auto then
        u1070.spam.connection_auto:Disconnect()
    end

    u1070.spam.auto_enabled = true
    u1070.spam.parries = 0
    table.clear(u1070.spam.auto_decay_at)
    local r4 = u1070.spam.auto_decay_at
    local r5 = u1070.spam
    local r0 = u1065:Connect(nil)
end

u1070.spam.auto_start = __S[3]

__S[3] = function()
    u1070.spam.auto_enabled = false
    u1070.spam.parries = 0
    table.clear(u1070.spam.auto_decay_at)

    if u1070.spam.connection_auto then
        u1070.spam.connection_auto:Disconnect()
        u1070.spam.connection_auto = nil
    end
end

u1070.spam.auto_stop = __S[3]

__S[3] = function(r0, r1)
    u1070.player_mods.fov_enabled = r0
    local r2 = u1070.player_mods

    if not r1 then
        r1 = u1070.player_mods.fov
    end

    r2.fov = r1

    u1062.FieldOfView = r0 and u1070.player_mods.fov or 70
end

u1070.player_mods.set_fov = __S[3]

__S[3] = function(r0, r1)
    u1070.player_mods.speed_enabled = r0
    u1070.player_mods.speed = r1 or u1070.player_mods.speed

    if u1070.player_mods.speed_conn then
        u1070.player_mods.speed_conn:Disconnect()
        u1070.player_mods.speed_conn = nil
    end

    if r0 then
        local function r1_2()
            local v1 = u1061.Character
            local v2 = v1 and (v1:FindFirstChildOfClass("Humanoid"))

            if v2 then
                v2.WalkSpeed = u1070.player_mods.speed
            end
        end --[[ LPH_NO_VIRTUALIZE ]]

        u1070.player_mods.speed_conn = u1063:Connect(r1_2)
    else
        local r4 = u1061.Character

        if r4 then
            r4 = r4:FindFirstChildOfClass("Humanoid")
        end

        if r4 then
            r4.WalkSpeed = 36
        end
    end
end

u1070.player_mods.set_speed = __S[3]

__S[3] = function(r0, r1)
    u1070.player_mods.gravity_enabled = r0
    u1070.player_mods.gravity = r1 or u1070.player_mods.gravity
    local r2 = u797

    if r0 then
        r0 = u1070.player_mods.gravity
    end

    if not r0 then
        r0 = 196.2
    end

    r2.Gravity = r0
end

u1070.player_mods.set_gravity = __S[3]

__S[3] = function(r0, r1)
    u1070.player_mods.jump_power_enabled = r0
    local r2 = u1070.player_mods

    if not r1 then
        r1 = u1070.player_mods.jump_power
    end

    r2.jump_power = r1

    if u1070.player_mods.jump_conn then
        u1070.player_mods.jump_conn:Disconnect()
        u1070.player_mods.jump_conn = nil
    end

    if r0 then
        local function r1_2()
            local v1 = u1061.Character
            local v2 = v1 and (v1:FindFirstChildOfClass("Humanoid"))

            if not v2 then
                return
            end

            if v2.UseJumpPower then
                v2.JumpPower = u1070.player_mods.jump_power
            else
                v2.JumpHeight = u1070.player_mods.jump_power / 5
            end
        end --[[ LPH_NO_VIRTUALIZE ]]

        u1070.player_mods.jump_conn = u1063:Connect(r1_2)
    else
        local r3 = u1061.Character

        if r3 then
            r3 = r3:FindFirstChildOfClass("Humanoid")
        end

        if r3 then
            if r3.UseJumpPower then
                r3.JumpPower = 50
            else
                r3.JumpHeight = 7.2
            end
        end
    end
end

u1070.player_mods.set_jump_power = __S[3]

__S[3] = function(r0)
    u1070.player_mods.infinite_jump_enabled = r0

    if u1070.player_mods.infinite_jump_conn then
        u1070.player_mods.infinite_jump_conn:Disconnect()
        u1070.player_mods.infinite_jump_conn = nil
    end

    if r0 then
        local function r0_2()
            local r4 = u1061.Character

            if r4 then
                r4 = r4:FindFirstChildOfClass("Humanoid")
            end

            if r4 then
                r4:ChangeState(u824.HumanoidStateType.Jumping)
            end
        end

        u1070.player_mods.infinite_jump_conn = u1056.JumpRequest:Connect(r0_2)
    end
end

u1070.player_mods.set_infinite_jump = __S[3]

__S[3] = function()
    local r5 = u797:FindFirstChild("Balls")

    if not r5 then
        return nil
    end

    local r293 = r5:GetChildren()

    for r2, r3 in ipairs(r293) do
        if r3:IsA("BasePart") then
            return r3
        end
    end

    return nil
end

u1070.ball_trail.get_ball = __S[3]

__S[3] = function()
    local r0 = u1070.ball_trail.color

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, r0),
        ColorSequenceKeypoint.new(0.5, u820.new(math.min(r0.R * 1.3, 1), math.min(r0.G * 1.3, 1), math.min(r0.B * 1.3, 1))),
        ColorSequenceKeypoint.new(1, r0)
    })
end

u1070.ball_trail.build_color_sequence = __S[3]

__S[3] = function(r0)
    u1070.ball_trail.detach()
    local r9 = u1070.ball_trail.num_trails

    for r1 = 1, r9 do
        local r10 = r1 / r9 * 3.141592653589793 * 2
        local r17 = math.random(150, 250) / 100
        local r3 = math.random(-150, 150) / 100
        local r18 = u850.new("Attachment")
        r18.Position = Vector3.new(math.cos(r10) * r17, r3, math.sin(r10) * r17)
        r18.Parent = r0
        local r2 = u850.new("Attachment")
        r2.Position = Vector3.new(math.cos(r10 + 3.141592653589793 * 0.7) * r17 * 1.3, -r3, math.sin(r10 + 3.141592653589793 * 0.7) * r17 * 1.3)
        r2.Parent = r0
        local r19 = u850.new("Trail")
        r19.Attachment0 = r18
        r19.Attachment1 = r2
        r19.Lifetime = 0.6
        r19.MinLength = 0
        r19.FaceCamera = true
        r19.LightEmission = 1
        r19.LightInfluence = 0
        r19.Texture = "rbxassetid://5029929719"
        r19.TextureMode = u824.TextureMode.Stretch
        r19.Color = u1070.ball_trail.build_color_sequence()

        r19.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.3, 0),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })

        r19.WidthScale = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.3, 0.25),
            NumberSequenceKeypoint.new(0.7, 0.15),
            NumberSequenceKeypoint.new(1, 0.02)
        })

        r19.Parent = r0

        table.insert(u1070.ball_trail.attachments, {
            a0 = r18,
            a1 = r2,
            trail = r19,
            baseAngle = r10,
            angle = 0,
            speed = math.random(15, 30) / 10,
            spiralSpeed = math.random(25, 45) / 10,
            radiusMultiplier = math.random(80, 120) / 100,
            pulseOffset = math.random() * 3.141592653589793 * 2,
            baseRadius = r17,
            baseHeight = r3,
            chaosSpeed = math.random(10, 20) / 10
        })
    end
end

u1070.ball_trail.attach = __S[3]

__S[3] = function()
    for r1, r2 in ipairs(u1070.ball_trail.attachments) do
        if r2.a0 and r2.a0.Parent then
            r2.a0:Destroy()
        end

        if r2.a1 and r2.a1.Parent then
            r2.a1:Destroy()
        end

        if r2.trail and r2.trail.Parent then
            r2.trail:Destroy()
        end
    end

    u1070.ball_trail.attachments = {}
end

u1070.ball_trail.detach = __S[3]

__S[6] = function(v1)
    if not u1070.ball_trail.active then
        return
    end

    local v2 = u817()

    for v3, v4 in u812(u1070.ball_trail.attachments) do
        if not v4.a0.Parent then
            continue
        end

        v4.angle = v4.angle + v4.speed * v1
        local v5 = v4.angle * v4.spiralSpeed
        local v6, v7, v8 = u827.sin(v2 * 4 + v4.pulseOffset) * 0.4 + 1, u827.sin(v4.angle * 3) * 0.7, u827.sin(v2 * v4.chaosSpeed + v4.pulseOffset) * 0.5
        local v9 = v4.baseRadius * v4.radiusMultiplier * v6
        local v10 = v4.baseRadius * 1.3 * v4.radiusMultiplier * v6
        v4.a0.Position = u818.new(u827.cos(v4.baseAngle + v4.angle) * v9 + u827.cos(v5) * 0.6, v4.baseHeight + u827.sin((v4.baseAngle + v4.angle) * 3) * 0.8 + v7 + v8 + u827.sin(v5 * 2) * 0.6, u827.sin(v4.baseAngle + v4.angle) * v9 + u827.sin(v5) * 0.6)
        v4.a1.Position = u818.new(u827.cos(v4.baseAngle + v4.angle + u827.pi * 0.7) * v10 + u827.sin(v5 * 1.3) * 0.5, -v4.baseHeight + u827.cos((v4.baseAngle + v4.angle) * 2.5) * 0.8 - v7 - v8 + u827.cos(v5 * 1.7) * 0.5, u827.sin(v4.baseAngle + v4.angle + u827.pi * 0.7) * v10 + u827.cos(v5 * 1.1) * 0.5)
        v4.trail.LightEmission = u827.sin(v2 * 5 + v4.pulseOffset) * 0.4 + 0.6
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.ball_trail.animate = __S[6]

__S[3] = function()
    if u1070.ball_trail.active then
        return
    end

    u1070.ball_trail.active = true;

    (function()
        local r0 = u1070.ball_trail.get_ball()

        if r0 then
            u1070.ball_trail.attach(r0)
        end
    end)()

    local function r2(v1)
        if not u1070.ball_trail.active then
            return
        end

        local v2 = u1070.ball_trail.get_ball()

        if not v2 then
            u1070.ball_trail.detach()
            return
        end

        if #u1070.ball_trail.attachments == 0 then
            u1070.ball_trail.attach(v2)
        end

        u1070.ball_trail.animate(v1)
    end --[[ LPH_NO_VIRTUALIZE ]]

    u1070.ball_trail.connection = u1063:Connect(r2)
end

u1070.ball_trail.start = __S[3]

__S[3] = function()
    if not u1070.ball_trail.active then
        return
    end

    u1070.ball_trail.active = false

    if u1070.ball_trail.connection then
        u1070.ball_trail.connection:Disconnect()
        u1070.ball_trail.connection = nil
    end

    u1070.ball_trail.detach()
end

u1070.ball_trail.stop = __S[3]

__S[3] = function(r0)
    u1070.ball_trail.color = r0

    for r2, r3 in ipairs(u1070.ball_trail.attachments) do
        if r3.trail and r3.trail.Parent then
            r3.trail.Color = u1070.ball_trail.build_color_sequence()
        end
    end
end

u1070.ball_trail.update_color = __S[3]

__S[3] = function()
    if u1070.ball_velocity.active then
        return
    end

    u1070.ball_velocity.active = true
    u1070.ball_velocity.peak = {}
    local r6 = u858()
    r6.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    local u1193 = u847("Frame")
    u1193.Size = u821.new(0, 230, 0, 130)
    u1193.Position = u821.new(0, 20, 0, 150)
    u1193.BackgroundColor3 = u820.fromRGB(17, 17, 24)
    u1193.BorderSizePixel = 0
    u1193.Parent = r6
    local r0 = u850.new("UICorner")
    r0.CornerRadius = u822.new(0, 12)
    r0.Parent = u1193
    local r0_2 = u850.new("UIStroke")
    r0_2.Thickness = 1
    r0_2.Color = u820.fromRGB(36, 40, 58)
    r0_2.Parent = u1193
    local r9 = u850.new("Frame")
    r9.Size = u821.new(1, 0, 0, 34)
    r9.BackgroundColor3 = u820.fromRGB(13, 13, 20)
    r9.BorderSizePixel = 0
    r9.Parent = u1193
    local r0_3 = u850.new("UICorner")
    r0_3.CornerRadius = u822.new(0, 12)
    r0_3.Parent = r9
    local r0_4 = u850.new("Frame")
    r0_4.Size = u821.new(1, 0, 0, 12)
    r0_4.Position = u821.new(0, 0, 1, -12)
    r0_4.BackgroundColor3 = u820.fromRGB(13, 13, 20)
    r0_4.BorderSizePixel = 0
    r0_4.Parent = r9
    local r0_5 = u850.new("TextLabel")
    r0_5.Size = u821.new(1, -16, 1, 0)
    r0_5.Position = u821.new(0, 12, 0, 0)
    r0_5.BackgroundTransparency = 1
    r0_5.Text = "Ball Stats"
    r0_5.TextColor3 = u820.fromRGB(235, 235, 245)
    r0_5.TextSize = 13
    r0_5.Font = u824.Font.GothamBold
    r0_5.TextXAlignment = u824.TextXAlignment.Left
    r0_5.Parent = r9
    local u1194 = u850.new("Frame")
    u1194.Size = u821.new(1, -24, 1, -44)
    u1194.Position = u821.new(0, 12, 0, 40)
    u1194.BackgroundTransparency = 1
    u1194.Parent = u1193

    local function r4(r0, r1)
        local r3 = u850.new("Frame")
        r3.Size = u821.new(1, 0, 0, 38)
        r3.Position = u821.new(0, 0, 0, r1)
        r3.BackgroundTransparency = 1
        r3.Parent = u1194
        local r2 = u850.new("TextLabel")
        r2.Size = u821.new(1, 0, 0, 14)
        r2.Position = u821.new(0, 0, 0, 0)
        r2.BackgroundTransparency = 1
        r2.Text = r0
        r2.TextColor3 = u820.fromRGB(148, 152, 185)
        r2.TextSize = 11
        r2.Font = u824.Font.Gotham
        r2.TextXAlignment = u824.TextXAlignment.Left
        r2.Parent = r3
        local r2_2 = u850.new("TextLabel")
        r2_2.Size = u821.new(1, 0, 0, 22)
        r2_2.Position = u821.new(0, 0, 0, 15)
        r2_2.BackgroundTransparency = 1
        r2_2.Text = "0.0"
        r2_2.TextColor3 = u820.fromRGB(172, 178, 255)
        r2_2.TextSize = 18
        r2_2.Font = u824.Font.GothamBold
        r2_2.TextXAlignment = u824.TextXAlignment.Left
        r2_2.Parent = r3
        return r2_2
    end

    local u1195 = r4("Current Velocity", 0)
    local u1196 = r4("Peak Velocity", 42)
    local u1197 = false
    local u1198
    local u1199

    r9.InputBegan:Connect(function(r0)
        if r0.UserInputType == u824.UserInputType.MouseButton1 or r0.UserInputType == u824.UserInputType.Touch then
            u1197 = true
            u1198 = r0.Position
            u1199 = u1193.Position
        end
    end)

    u1056.InputChanged:Connect(function(r0)
        local r2 = u1197

        if u1197 and (r0.UserInputType == u824.UserInputType.MouseMovement or r0.UserInputType == u824.UserInputType.Touch) then
            local r1 = r0.Position - u1198
            u1193.Position = u821.new(u1199.X.Scale, u1199.X.Offset + r1.X, u1199.Y.Scale, u1199.Y.Offset + r1.Y)
        end
    end)

    u1056.InputEnded:Connect(function(r0)
        if r0.UserInputType == u824.UserInputType.MouseButton1 or r0.UserInputType == u824.UserInputType.Touch then
            u1197 = false
        end
    end)

    u1070.ball_velocity.gui = r6

    local function r6_2()
    end

    u1070.ball_velocity.connection = u1063:Connect(r6_2)
end

u1070.ball_velocity.start = __S[3]

__S[3] = function()
    if not u1070.ball_velocity.active then
        return
    end

    u1070.ball_velocity.active = false

    if u1070.ball_velocity.connection then
        u1070.ball_velocity.connection:Disconnect()
        u1070.ball_velocity.connection = nil
    end

    if u1070.ball_velocity.gui then
        u1070.ball_velocity.gui:Destroy()
        u1070.ball_velocity.gui = nil
    end

    u1070.ball_velocity.peak = {}
end

u1070.ball_velocity.stop = __S[3]

__S[3] = function()
    if u1070.no_render.active then
        return
    end

    u1070.no_render.active = true

    pcall(function()
        u1061.PlayerScripts.EffectScripts.ClientFX.Disabled = true
    end)

    if u1067 then
        u1070.no_render.connection = u1067.ChildAdded:Connect(function(r0)
            if u1070.no_render.active then
                u796:GetService("Debris"):AddItem(r0, 0)
            end
        end)
    end
end

u1070.no_render.start = __S[3]

__S[3] = function()
    if not u1070.no_render.active then
        return
    end

    u1070.no_render.active = false

    pcall(function()
        u1061.PlayerScripts.EffectScripts.ClientFX.Disabled = false
    end)

    if u1070.no_render.connection then
        u1070.no_render.connection:Disconnect()
        u1070.no_render.connection = nil
    end
end

u1070.no_render.stop = __S[3]

__S[3] = function()
    if u1070.ball_indicator.active then
        return
    end

    u1070.ball_indicator.active = true
    local r6 = u858()
    r6.ZIndexBehavior = u824.ZIndexBehavior.Sibling
    local u1200 = u850.new("Frame")
    u1200.Size = u821.new(0, u1070.ball_indicator.size, 0, u1070.ball_indicator.size)
    u1200.Position = u821.new(0.5, 0, 0.5, 0)
    u1200.AnchorPoint = Vector2.new(0.5, 0.5)
    u1200.BackgroundTransparency = 1
    u1200.Parent = r6
    local u1201 = u850.new("ImageLabel")
    u1201.BackgroundTransparency = 1
    u1201.Size = u821.new(1, 0, 1, 0)
    u1201.Position = u821.new(0.5, 0, 0.5, 0)
    u1201.AnchorPoint = Vector2.new(0.5, 0.5)
    u1201.Image = "rbxassetid://18604510750"
    u1201.ImageColor3 = u820.new(0, 0, 0)
    u1201.Parent = u1200
    u1070.ball_indicator.gui = r6

    local function r2()
    end

    u1070.ball_indicator.connection = u1064:Connect(r2)
end

u1070.ball_indicator.start = __S[3]

__S[3] = function()
    if not u1070.ball_indicator.active then
        return
    end

    u1070.ball_indicator.active = false

    if u1070.ball_indicator.connection then
        u1070.ball_indicator.connection:Disconnect()
        u1070.ball_indicator.connection = nil
    end

    if u1070.ball_indicator.gui then
        u1070.ball_indicator.gui:Destroy()
        u1070.ball_indicator.gui = nil
    end
end

u1070.ball_indicator.stop = __S[3]

__S[3] = function(r0)
    local u1202 = u1070.plushies.models[r0]

    if not u1202 then
        return nil
    end

    if not u1070.plushies.loaded_models[r0] then
        local function r9()
            return u796:GetObjects(u1202)[1]
        end

        local r8, r9_2 = pcall(r9)

        if not r8 or not r9_2 then
            return nil
        end

        u1070.plushies.loaded_models[r0] = r9_2
    end

    local r5 = u1070.plushies.loaded_models[r0]:Clone()
    r5.Name = r0
    local r12 = u1070.plushies.scales[r0] or 1.5
    local r296 = r5:GetDescendants()

    for r3, r4 in ipairs(r296) do
        if r4:IsA("BasePart") or r4:IsA("MeshPart") then
            r4.CanCollide = false
            r4.Anchored = false
            r4.Size = r4.Size * r12
            local r6 = r4:FindFirstChildOfClass("SpecialMesh")

            if r6 then
                r6.Scale = r6.Scale * r12
            end
        end
    end

    local r2 = r5:FindFirstChildOfClass("BasePart") or r5:FindFirstChildOfClass("MeshPart")

    if r2 then
        r5.PrimaryPart = r2
    end

    return r5
end

u1070.plushies.create = __S[3]

__S[6] = function()
    if not u1070.plushies.active then
        return
    end

    local v1 = u1061.Character

    if not v1 or not v1.PrimaryPart or not u1070.plushies.folder then
        return
    end

    local v2 = 1

    for v3 in u811(u1070.plushies.active_types) do
        local v4, v5 = u1070.plushies.positions[(v2 - 1) % #u1070.plushies.positions + 1], u1070.plushies.folder:FindFirstChild(v3)

        if not v5 then
            local v6 = u1070.plushies.create(v3)

            if v6 then
                v6.Parent = u1070.plushies.folder
                v6:SetPrimaryPartCFrame(u819.new(v1.PrimaryPart.Position + v4))
                v5 = v6
            end
        end

        if v5 and v5.PrimaryPart then
            local v7 = v5.PrimaryPart
            local v8 = u818.new(0, u827.sin(u817() * 2) * 0.3, 0)
            local v9, v10 = v1.PrimaryPart.CFrame * u819.new(v4 + v8) * (u1070.plushies.rotations[v3] or (u819.new())), v7:FindFirstChild("PlushieBP")

            if not v10 then
                v10 = u850.new("BodyPosition")
                v10.Name = "PlushieBP"
                v10.MaxForce = u818.new(40000, 40000, 40000)
                v10.P = 10000
                v10.D = 1000
                v10.Parent = v7
            end

            v10.Position = v9.Position
            v7.CFrame = u819.new(v7.Position) * v9.Rotation
        end

        v2 += 1
    end

    for v11, v12 in u812(u1070.plushies.folder:GetChildren()) do
        if not u1070.plushies.active_types[v12.Name] then
            v12:Destroy()
        end
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.plushies.update = __S[6]

__S[3] = function()
    if u1070.plushies.active then
        return
    end

    u1070.plushies.active = true
    u1070.plushies.folder = u850.new("Folder")
    u1070.plushies.folder.Name = "Plushies_Temp"
    u1070.plushies.folder.Parent = u1058
    u1070.plushies.connection = u1064:Connect(u1070.plushies.update)
end

u1070.plushies.start = __S[3]

__S[3] = function()
    if not u1070.plushies.active then
        return
    end

    u1070.plushies.active = false

    if u1070.plushies.connection then
        u1070.plushies.connection:Disconnect()
        u1070.plushies.connection = nil
    end

    if u1070.plushies.folder then
        u1070.plushies.folder:Destroy()
        u1070.plushies.folder = nil
    end
end

u1070.plushies.stop = __S[3]

__S[3] = function()
    if u1070.orbit_ball.active then
        return
    end

    u1070.orbit_ball.active = true
    u1070.orbit_ball.angle = 0

    local function r2()
    end

    u1070.orbit_ball.connection = u1063:Connect(r2)
end

u1070.orbit_ball.start = __S[3]

__S[3] = function()
    if not u1070.orbit_ball.active then
        return
    end

    u1070.orbit_ball.active = false
    local r5 = u1061.Character

    if r5 then
        r5 = r5:FindFirstChildOfClass("Humanoid")
    end

    if r5 then
        u1062.CameraSubject = r5
    end

    if u1070.orbit_ball.connection then
        u1070.orbit_ball.connection:Disconnect()
        u1070.orbit_ball.connection = nil
    end
end

u1070.orbit_ball.stop = __S[3]

__S[6] = function()
    if not u1070.winstreak.enabled then
        if u1070.winstreak.conn then
            u1070.winstreak.conn:Disconnect()
            u1070.winstreak.conn = nil
        end

        if u1070.winstreak.enabled_conn then
            u1070.winstreak.enabled_conn:Disconnect()
            u1070.winstreak.enabled_conn = nil
        end

        return
    end

    local v1 = u1061.Character

    if not v1 then
        return
    end

    local v2 = v1:FindFirstChild("WinStreakDisplay")

    if not v2 then
        v2 = v1:WaitForChild("WinStreakDisplay", 5)
    end

    if not v2 then
        return
    end

    v1 = v2:FindFirstChild("Main")

    if not v1 then
        return
    end

    local v3, v4 = v1:FindFirstChild("Icon"), v1:FindFirstChild("Value")

    if not v3 or not v4 then
        return
    end

    if u1070.winstreak.original_enabled == nil then
        u1070.winstreak.original_enabled = v2.Enabled
    end

    if not u1070.winstreak.original_text or u1070.winstreak.original_text == "" then
        u1070.winstreak.original_text = v4.Text
    end

    if not u1070.winstreak.original_icon or u1070.winstreak.original_icon == "" then
        u1070.winstreak.original_icon = v3.Image
    end

    local v5 = u1070.winstreak.streak or "1"
    v1 = u826.format("<b><stroke color='rgb(0, 0, 0)' thickness='2'>%s</stroke></b>", u814(v5))
    local v6 = u815(v5)
    v5 = if v6 and v6 >= 10 then true else false

    if u1070.winstreak.conn then
        u1070.winstreak.conn:Disconnect()
        u1070.winstreak.conn = nil
    end

    if u1070.winstreak.enabled_conn then
        u1070.winstreak.enabled_conn:Disconnect()
        u1070.winstreak.enabled_conn = nil
    end

    local v7 = false
    v3.Image = v5 and "rbxassetid://75598166115655" or "rbxassetid://89658127170771"
    v4.Text = v1
    v2.Enabled = true

    u1070.winstreak.conn = v4:GetPropertyChangedSignal("Text"):Connect(function()
        if v7 then
            return
        end

        u1070.winstreak.original_text = v4.Text
        v7 = true
        local v8 = u1070.winstreak.streak or "1"
        local v9 = u815(v8)
        v3.Image = (if v9 and v9 >= 10 then true else false) and "rbxassetid://75598166115655" or "rbxassetid://89658127170771"
        v4.Text = u826.format("<b><stroke color='rgb(0, 0, 0)' thickness='2'>%s</stroke></b>", u814(v8))
        v7 = false
    end)

    u1070.winstreak.enabled_conn = v2:GetPropertyChangedSignal("Enabled"):Connect(function()
        if v7 then
            return
        end

        u1070.winstreak.original_enabled = v2.Enabled
        v7 = true
        v2.Enabled = true
        v7 = false
    end)
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.winstreak.update = __S[6]

__S[3] = function()
    u1070.winstreak.enabled = true
    local u1203

    if not u1070.winstreak.char_conn then
        local r4 = u1070.winstreak
        local r1 = u1061.CharacterAdded
        u1203 = r1.Connect

        u1203 = u1203(r1, function()
            u1070.winstreak.original_text = nil
            u1070.winstreak.original_icon = nil
            u1070.winstreak.original_enabled = nil
            task.wait(1.5)
            pcall(u1070.winstreak.update)
        end)

        r4.char_conn = u1203
    end

    u1203 = u1070.winstreak
    u1203 = u1203.update
    pcall(u1203)
end

u1070.winstreak.start = __S[3]

__S[3] = function()
    u1070.winstreak.enabled = false

    if u1070.winstreak.char_conn then
        u1070.winstreak.char_conn:Disconnect()
        u1070.winstreak.char_conn = nil
    end

    if u1070.winstreak.conn then
        u1070.winstreak.conn:Disconnect()
        u1070.winstreak.conn = nil
    end

    if u1070.winstreak.enabled_conn then
        u1070.winstreak.enabled_conn:Disconnect()
        u1070.winstreak.enabled_conn = nil
    end

    local r4 = u1061.Character

    if r4 then
        local r6 = r4:FindFirstChild("WinStreakDisplay")

        if r6 then
            local r5 = r6:FindFirstChild("Main")

            if r5 then
                local r4_2 = r5:FindFirstChild("Icon")
                local r1 = r5:FindFirstChild("Value")

                if r4_2 and r1 then
                    if u1070.winstreak.original_text and u1070.winstreak.original_text ~= "" then
                        r1.Text = u1070.winstreak.original_text
                    end

                    if u1070.winstreak.original_icon and u1070.winstreak.original_icon ~= "" then
                        r4_2.Image = u1070.winstreak.original_icon
                    end
                end
            end

            if u1070.winstreak.original_enabled ~= nil then
                r6.Enabled = u1070.winstreak.original_enabled
            end
        end
    end

    u1070.winstreak.original_text = nil
    u1070.winstreak.original_icon = nil
    u1070.winstreak.original_enabled = nil
end

u1070.winstreak.stop = __S[3]

__S[6] = function()
    if not u1070.custom_win.enabled then
        return
    end

    local v1 = u1061:FindFirstChild("PlayerGui")

    if not v1 then
        return
    end

    local v2 = v1:FindFirstChild("announcer")

    if not v2 then
        return
    end

    v1 = u1070.custom_win.kill_message

    if v1 ~= nil and v1 ~= "" then
        local v3 = v2:FindFirstChild("Killed")

        if v3 and (v3:IsA("TextLabel") or (v3:IsA("TextBox"))) then
            if v3.Text ~= v1 then
                v3.Text = v1
            end
        end
    end

    v1 = u1070.custom_win.win_message

    if v1 ~= nil and v1 ~= "" then
        local v4 = v2:FindFirstChild("Winner")

        if v4 and (v4:IsA("TextLabel") or (v4:IsA("TextBox"))) then
            if v4.Text ~= v1 then
                v4.Text = v1
            end
        end
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u1070.custom_win.update = __S[6]

__S[3] = function()
    u1070.custom_win.stop()
    u1070.custom_win.enabled = true
    local r0 = u1061:WaitForChild("PlayerGui", 10)

    if not r0 then
        return
    end

    local r5 = r0:WaitForChild("announcer", 10)

    if not r5 then
        return
    end

    local function u1204(u1205, u1206)
        if not u1205 then
            return
        end

        table.insert(u1070.custom_win.connections, u1205.Changed:Connect(function(r0)
            if r0 ~= "Text" or not u1070.custom_win.enabled then
                return
            end

            local r2 = u1206()

            if r2 ~= nil and r2 ~= "" and u1205.Text ~= r2 then
                u1205.Text = r2
            end
        end))

        local r2 = u1206()

        if r2 ~= nil and r2 ~= "" and u1205.Text ~= r2 then
            u1205.Text = r2
        end
    end

    u1204(r5:WaitForChild("Killed", 10), function()
        return u1070.custom_win.kill_message
    end)

    u1204(r5:FindFirstChild("Winner"), function()
        return u1070.custom_win.win_message
    end)

    table.insert(u1070.custom_win.connections, r5.ChildAdded:Connect(function(r0)
        if r0.Name == "Winner" then
            u1204(r0, function()
                return u1070.custom_win.win_message
            end)
        end

        if r0.Name == "Killed" then
            u1204(r0, function()
                return u1070.custom_win.kill_message
            end)
        end
    end))
end

u1070.custom_win.start = __S[3]

__S[3] = function()
    u1070.custom_win.enabled = false

    for r1, u1207 in ipairs(u1070.custom_win.connections) do
        pcall(function()
            u1207:Disconnect()
        end)
    end

    table.clear(u1070.custom_win.connections)
end

u1070.custom_win.stop = __S[3]

local function u1208(r0)
    if type(r0) ~= "string" or r0 == "" then
        return nil
    end

    local r2 = u1058:FindFirstChild("Alive")

    if r2 then
        r2 = r2:FindFirstChild(r0)
    end

    local r3 = r2 or u1058:FindFirstChild(r0)

    if r3 and r3:IsA("Model") then
        local r2_2 = r3:FindFirstChild("HumanoidRootPart") or r3.PrimaryPart or r3:FindFirstChildWhichIsA("BasePart")

        if r2_2 then
            return r2_2.Position
        end
    end

    return nil
end

local function u1209()
    local r290 = u1070.ball.get_all()
    local r6 = 0

    for r1, r2 in ipairs(r290) do
        local r3 = u1070.ball.get_velocity(r2.part, r2.model)

        if r3 then
            local r4 = r3.Magnitude

            if r6 < r4 then
                r6 = r4
            end
        end
    end

    return r6
end

local function u1210(...)
    if not u1070.config.kill_pre_click then
        return
    end

    local v1 = u1070.player.get_root()

    if not v1 then
        return
    end

    if not u1070.player.is_alive() then
        return
    end

    local v2 = u1070.config.kill_pre_click_speed or 1

    if v2 > 1 and u1209() < v2 then
        return
    end

    local v3 = u1070.config.kill_pre_click_range or 30
    local v4 = v1.Position
    local v5 = false

    for v6 = 1, u806("#", ...) do
        v2 = u806(v6, ...)
        v6 = u1208(if u809(v2) == "string" then v2 else if u809(v2) == "table" then v2.Name or v2.DisplayName or v2.Victim or v2.Player else nil)

        if v6 and (v4 - v6).Magnitude <= v3 then
            v5 = true
            break
        end
    end

    if not v5 then
        local v7 = u1061.Character

        for v8, v9 in u812(u1070.player.get_alive_chars()) do
            if v9 ~= v7 then
                v8 = v9:FindFirstChild("HumanoidRootPart") or v9.PrimaryPart

                if v8 and (v4 - v8.Position).Magnitude <= v3 then
                    v5 = true
                    break
                end
            end
        end
    end

    if v5 then
        u808(u1070.parry.execute)
    end
end --[[ LPH_NO_VIRTUALIZE ]]

u828.spawn(function()
    local r5 = u1057:WaitForChild("Remotes", 30)

    if not r5 then
        return
    end

    local u1211 = r5:WaitForChild("Killed", 30)

    if not u1211 then
        return
    end

    pcall(function()
        u1211.OnClientEvent:Connect(u1210)
    end)
end)

__S[3] = function()
    u808(u1070.parry.process)
end --[[ LPH_NO_VIRTUALIZE ]]

u1063:Connect(__S[3])
u1070.animation.init()
u1070.avatar_changer.save_original()
__S[5] = __S[84]:create_tab("Combat", "sword")
__S[6] = __S[84]:create_tab("Detections", "shield")
__S[7] = __S[84]:create_tab("Visuals", "eye")
__S[8] = __S[84]:create_tab("Player", "user")
__S[9] = __S[84]:create_tab("Sword", "package")
__S[10] = __S[84]:create_tab("Avatar", "users")
__S[11] = __S[84]:create_tab("Blatant", "skull")
__S[12] = __S[84]:create_tab("Misc", "settings")

__S[13] = __S[5]:create_module({
    title = "Auto Parry",
    description = "automatic ball deflection",
    section = "left",
    flag = "auto_parry",
    notify = true,
    callback = function(r0)
        u1070.config.auto_parry = r0
    end
})

local u1212 = __S[13]:create_slider({
    title = "Accuracy",
    flag = "parry_accuracy",
    value = 75,
    minimum_value = 1,
    maximum_value = 100,
    decimals = 0,
    callback = function(r0)
        if not u1070.config.randomize_accuracy then
            u1070.config._accuracy_before_random = r0
        end

        u1070.config.accuracy = r0
    end
})

__S[13]:create_checkbox({
    title = "Randomize Accuracy",
    flag = "randomize_accuracy",
    callback = function(r0)
        u1070.config.randomize_accuracy = r0

        if r0 then
            u1070.config._accuracy_before_random = u1070.config.accuracy
        else
            local r1 = tonumber(u1070.config._accuracy_before_random or u864._config._flags.parry_accuracy or u1070.config.accuracy)

            if r1 then
                local r4 = math.clamp(math.floor(r1 + 0.5), 1, 100)
                u1070.config.accuracy = r4
                u864._config._flags.parry_accuracy = r4
                u867:save(u796.GameId, u864._config)

                if u1212 and u1212.set_percentage then
                    u1212:set_percentage(r4)
                end
            end
        end
    end
})

__S[13]:create_doubleslider({
    title = "Random Accuracy",
    flag = "random_accuracy_range",
    value = {25, 85},
    minimum_value = 1,
    maximum_value = 100,
    decimals = 0,
    callback = function(r0, r1)
        u1070.config.random_accuracy_min = r0
        u1070.config.random_accuracy_max = r1
    end
})

__S[13]:create_dropdown({
    title = "Parry Mode",
    flag = "parry_mode",
    options = {"Remote", "Keypress"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.config.parry_mode = r0
    end
})

__S[13]:create_divider({showtopic = true, title = "Pre Click"})

__S[13]:create_checkbox({
    title = "Kill Pre Click",
    flag = "kill_pre_click",
    notify = true,
    callback = function(r0)
        u1070.config.kill_pre_click = r0
    end
})

__S[13]:create_slider({
    title = "Pre Click Range",
    flag = "kill_pre_click_range",
    value = 30,
    minimum_value = 5,
    maximum_value = 100,
    decimals = 0,
    callback = function(r0)
        u1070.config.kill_pre_click_range = r0
    end
})

__S[13]:create_slider({
    title = "Pre Click Ball Speed",
    flag = "kill_pre_click_speed",
    value = 1,
    minimum_value = 1,
    maximum_value = 1000,
    decimals = 0,
    callback = function(r0)
        u1070.config.kill_pre_click_speed = r0
    end
})

__S[13]:create_divider({showtopic = true, title = "Abilities"})

__S[13]:create_checkbox({
    title = "Cooldown Protection",
    flag = "cooldown_protection",
    callback = function(r0)
        u1070.ability.cooldown_protection = r0
    end
})

__S[13]:create_checkbox({
    title = "Auto Ability",
    flag = "auto_ability",
    callback = function(r0)
        u1070.ability.auto_ability = r0
    end
})

__S[13]:create_divider({showtopic = true, title = "Curve"})

__S[13]:create_dropdown({
    title = "Curve Mode",
    flag = "curve_mode",
    options = u1073,
    maximum_options = 7,
    multi_dropdown = false,
    keybind = true,
    notify = true,
    callback = function(r0)
        for r2, r3 in ipairs(u1073) do
            if r3 == r0 then
                u1070.config.curve_mode = r2
                break
            end
        end
    end
})

__S[5]:create_module({
    title = "Triggerbot",
    description = "fires when ball targets you",
    section = "left",
    flag = "triggerbot",
    notify = true,
    callback = function(r0)
        if u1070.config.is_mobile then
            if r0 then
                if not u1070.mobile_guis.triggerbot then
                    local u1213 = u1079("Trigger", 0.7, u820.fromRGB(255, 100, 0))
                    u1070.mobile_guis.triggerbot = u1213
                    local u1214 = 0
                    local u1215 = false

                    u1213.button.InputBegan:Connect(function(r0)
                        if r0.UserInputType == u824.UserInputType.Touch then
                            u1214 = u817()
                            u1215 = false
                        end
                    end)

                    u1213.button.InputChanged:Connect(function(r0)
                        if r0.UserInputType == u824.UserInputType.Touch and u817() - u1214 > 0.15 then
                            u1215 = true
                        end
                    end)

                    u1213.button.InputEnded:Connect(function(r0)
                        if r0.UserInputType ~= u824.UserInputType.Touch or u1215 then
                            return
                        end

                        local r5 = not u1070.triggerbot.enabled
                        u1070.triggerbot.set(r5)
                        u1213.label.Text = r5 and "ON" or "Trigger"
                        local r2 = u1213.label

                        if r5 then
                            r5 = u820.fromRGB(255, 100, 0)
                        end

                        if not r5 then
                            r5 = u820.fromRGB(235, 235, 245)
                        end

                        r2.TextColor3 = r5
                    end)
                end
            else
                u1070.triggerbot.set(false)

                if u1070.mobile_guis.triggerbot then
                    u1070.mobile_guis.triggerbot.gui:Destroy()
                    u1070.mobile_guis.triggerbot = nil
                end
            end
        else
            u1070.triggerbot.set(r0)
        end
    end
})

__S[13] = __S[5]:create_module({
    title = "Manual Spam",
    description = "continuously spams parry",
    section = "right",
    flag = "manual_spam",
    notify = true,
    callback = function(r0)
        if u1070.config.is_mobile then
            if r0 then
                if not u1070.mobile_guis.manual_spam then
                    local u1216 = u1079("Spam", 0.8, u820.fromRGB(99, 102, 241))
                    u1070.mobile_guis.manual_spam = u1216
                    local u1217 = 0
                    local u1218 = false

                    u1216.button.InputBegan:Connect(function(r0)
                        if r0.UserInputType == u824.UserInputType.Touch then
                            u1217 = u817()
                            u1218 = false
                        end
                    end)

                    u1216.button.InputChanged:Connect(function(r0)
                        if r0.UserInputType ~= u824.UserInputType.Touch or not (u817() - u1217 > 0.15) then
                            return
                        end

                        u1218 = true
                    end)

                    u1216.button.InputEnded:Connect(function(r0)
                        if r0.UserInputType ~= u824.UserInputType.Touch or u1218 then
                            return
                        end

                        if u1070.spam.manual_enabled then
                            u1070.spam.manual_stop()
                            u1216.label.Text = "Spam"
                            u1216.label.TextColor3 = u820.fromRGB(235, 235, 245)
                        else
                            u1070.spam.manual_start()
                            u1216.label.Text = "ON"
                            u1216.label.TextColor3 = u820.fromRGB(99, 102, 241)
                        end
                    end)
                end
            else
                u1070.spam.manual_stop()

                if u1070.mobile_guis.manual_spam then
                    u1070.mobile_guis.manual_spam.gui:Destroy()
                    u1070.mobile_guis.manual_spam = nil
                end
            end
        elseif r0 then
            u1070.spam.manual_start()
        else
            u1070.spam.manual_stop()
        end
    end
})

__S[13]:create_dropdown({
    title = "Spam Mode",
    flag = "manual_spam_mode",
    options = {"Remote", "Keypress"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.spam.manual_mode = r0
    end
})

if not u1070.config.is_mobile then
    __S[13]:create_checkbox({
        title = "Animation Fix",
        flag = "manual_spam_anim_fix",
        callback = function(r0)
            u1070.spam.animation_fix_manual = r0
        end
    })
end

__S[13] = __S[5]:create_module({
    title = "Auto Spam",
    description = "spams based on ball proximity",
    section = "right",
    flag = "auto_spam",
    notify = true,
    callback = function(r0)
        if r0 then
            u1070.spam.auto_start()
        else
            u1070.spam.auto_stop()
        end
    end
})

__S[13]:create_dropdown({
    title = "Spam Mode",
    flag = "auto_spam_mode",
    options = {"Remote", "Keypress"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.spam.auto_mode = r0
    end
})

__S[13]:create_slider({
    title = "Parry Threshold",
    flag = "spam_threshold",
    value = 1.5,
    minimum_value = 1,
    maximum_value = 5,
    callback = function(r0)
        u1070.spam.threshold = r0
    end
})

if not u1070.config.is_mobile then
    __S[13]:create_checkbox({
        title = "Animation Fix",
        flag = "auto_spam_anim_fix",
        callback = function(r0)
            u1070.spam.animation_fix_auto = r0
        end
    })
end

__S[6]:create_module({
    title = "Infinity Detection",
    description = "ignore infinity ball",
    section = "left",
    flag = "detect_infinity",
    notify = true,
    callback = function(r0)
        u1070.detections.infinity = r0
    end
})

__S[6]:create_module({
    title = "Death Slash Detection",
    description = "ignore death slash ball",
    section = "right",
    flag = "detect_deathslash",
    notify = true,
    callback = function(r0)
        u1070.detections.deathslash = r0
    end
})

__S[13] = __S[7]:create_module({
    title = "Ball Trail",
    description = "trails on the ball",
    section = "left",
    flag = "ball_trail",
    callback = function(r0)
        if r0 then
            u1070.ball_trail.start()
        else
            u1070.ball_trail.stop()
        end
    end
})

__S[13]:create_slider({
    title = "Trail Count",
    flag = "ball_trail_count",
    value = 8,
    minimum_value = 1,
    maximum_value = 16,
    callback = function(r0)
        u1070.ball_trail.num_trails = r0

        if not u1070.ball_trail.active then
            return
        end

        local r1 = u1070.ball_trail.get_ball()

        if r1 then
            u1070.ball_trail.detach()
            u1070.ball_trail.attach(r1)
        end
    end
})

__S[13]:create_colorpicker({
    title = "Trail Color",
    flag = "ball_trail_color",
    value = u820.fromRGB(0, 255, 255),
    callback = function(r0)
        u1070.ball_trail.update_color(r0)
    end
})

__S[7]:create_module({
    title = "Parry Visualizer",
    description = "shows a forcefield ball on parry",
    section = "left",
    flag = "parry_visualizer",
    callback = function(r0)
        if r0 then
            u1070.parry_visualizer.start()
        else
            u1070.parry_visualizer.stop()
        end
    end
}):create_colorpicker({
    title = "Visualizer Color",
    flag = "parry_visualizer_color",
    value = u820.fromRGB(255, 255, 255),
    callback = function(r0)
        u1070.parry_visualizer.update_color(r0)
    end
})

__S[7]:create_module({
    title = "Parry Hits",
    description = "burst effect on every parry success",
    section = "left",
    flag = "parry_hits",
    callback = function(r0)
        if r0 then
            u1070.parry_hits.start()
        else
            u1070.parry_hits.stop()
        end
    end
}):create_colorpicker({
    title = "Hits Color",
    flag = "parry_hits_color",
    value = u820.fromRGB(255, 255, 255),
    callback = function(r0)
        u1070.parry_hits.update_color(r0)
    end
})

__S[13] = __S[7]:create_module({
    title = "Custom WinStreak",
    description = "Customize your client-side win streak display",
    section = "right",
    flag = "custom_winstreak",
    callback = function(r0)
        if r0 then
            u1070.winstreak.start()
        else
            u1070.winstreak.stop()
        end
    end
})

if u864._config._flags.custom_winstreak_amount == nil then
    u864._config._flags.custom_winstreak_amount = "1"
end

u1070.winstreak.streak = u864._config._flags.custom_winstreak_amount

if u864._config._flags.custom_winstreak then
    u828.spawn(u1070.winstreak.start)
end

__S[13]:create_textbox({
    title = "Streak Amount",
    flag = "custom_winstreak_amount",
    placeholder = "Enter streak value (e.g. 999)...",
    callback = function(r0)
        u1070.winstreak.streak = r0

        if u1070.winstreak.enabled then
            pcall(u1070.winstreak.update)
        end
    end
})

__S[13] = __S[7]:create_module({
    title = "Custom Win Message",
    description = "Customize announcer messages for win and kills",
    section = "right",
    flag = "custom_win_enabled",
    callback = function(r0)
        if r0 then
            u1070.custom_win.start()
        else
            u1070.custom_win.stop()
        end
    end
})

if u864._config._flags.custom_win_win_text == nil then
    __S[3] = u864._config._flags.custom_win_text
    __S[5] = u864._config._flags

    if __S[3] then
        __S[294] = __S[3] ~= ""

        if __S[3] == "" then
            __S[3] = __S[294]
        end
    else
        __S[3] = __S[3]
    end

    if not __S[3] then
        __S[3] = "Allusive"
    end

    __S[5].custom_win_win_text = __S[3]
end

if u864._config._flags.custom_win_kill_text == nil then
    __S[3] = u864._config._flags.custom_win_text
    __S[5] = u864._config._flags

    if __S[3] then
        __S[294] = __S[3] ~= ""

        if __S[3] == "" then
            __S[3] = __S[294]
        end
    else
        __S[3] = __S[3]
    end

    if not __S[3] then
        __S[3] = "Allusive"
    end

    __S[5].custom_win_kill_text = __S[3]
end

u1070.custom_win.win_message = u864._config._flags.custom_win_win_text
u1070.custom_win.kill_message = u864._config._flags.custom_win_kill_text

if u864._config._flags.custom_win_enabled then
    u828.spawn(u1070.custom_win.start)
end

__S[13]:create_textbox({
    title = "Win Message",
    flag = "custom_win_win_text",
    placeholder = "Enter win message...",
    callback = function(r0)
        u1070.custom_win.win_message = r0

        if u1070.custom_win.enabled then
            u1070.custom_win.update()
        end
    end
})

__S[13]:create_textbox({
    title = "Kill Message",
    flag = "custom_win_kill_text",
    placeholder = "Enter kill message...",
    callback = function(r0)
        u1070.custom_win.kill_message = r0

        if u1070.custom_win.enabled then
            u1070.custom_win.update()
        end
    end
})

__S[13] = __S[7]:create_module({
    title = "Ability ESP",
    description = "shows player equipped abilities",
    section = "left",
    flag = "ability_esp",
    callback = function(r0)
        if r0 then
            u1070.ability_esp.start()
        else
            u1070.ability_esp.stop()
        end
    end
})

__S[13]:create_divider({showtopic = true, title = "Name"})

__S[13]:create_checkbox({
    title = "Show Name",
    flag = "esp_show_name",
    value = false,
    callback = function(r0)
        u1070.ability_esp.show_name = r0
    end
})

__S[13]:create_dropdown({
    title = "Name Type",
    flag = "esp_name_mode",
    options = {"Display Name", "Username"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.ability_esp.name_mode = r0
    end
})

__S[13]:create_slider({
    title = "Name Size",
    flag = "esp_name_size",
    value = 18,
    minimum_value = 8,
    maximum_value = 36,
    callback = function(r0)
        u1070.ability_esp.name_size = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.nameDraw then
                r3.nameDraw.Size = r0
            end
        end
    end
})

__S[13]:create_colorpicker({
    title = "Name Color",
    flag = "esp_name_color",
    value = u820.fromRGB(255, 255, 255),
    callback = function(r0)
        u1070.ability_esp.name_color = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.nameDraw then
                r3.nameDraw.Color = r0
            end
        end
    end
})

__S[13]:create_divider({showtopic = true, title = "Ability"})

__S[13]:create_slider({
    title = "Ability Size",
    flag = "esp_ability_size",
    value = 16,
    minimum_value = 8,
    maximum_value = 36,
    callback = function(r0)
        u1070.ability_esp.ability_size = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.abilityDraw then
                r3.abilityDraw.Size = r0
            end
        end
    end
})

__S[13]:create_colorpicker({
    title = "Ability Color",
    flag = "esp_ability_color",
    value = u820.fromRGB(120, 200, 255),
    callback = function(r0)
        u1070.ability_esp.ability_color = r0

        for r2, r3 in pairs(u1070.ability_esp.drawings) do
            if r3.abilityDraw then
                r3.abilityDraw.Color = r0
            end
        end
    end
})

__S[7]:create_module({
    title = "Ball Velocity",
    description = "displays current and peak ball speed",
    section = "left",
    flag = "ball_velocity",
    callback = function(r0)
        if r0 then
            u1070.ball_velocity.start()
        else
            u1070.ball_velocity.stop()
        end
    end
})

__S[7]:create_module({
    title = "Ball Indicator",
    description = "shows ball direction on screen",
    section = "right",
    flag = "ball_indicator",
    callback = function(r0)
        if r0 then
            u1070.ball_indicator.start()
        else
            u1070.ball_indicator.stop()
        end
    end
})

__S[7]:create_module({
    title = "No Render",
    description = "disables client effects",
    section = "right",
    flag = "no_render",
    callback = function(r0)
        if r0 then
            u1070.no_render.start()
        else
            u1070.no_render.stop()
        end
    end
})

__S[7]:create_module({
    title = "Plushies",
    description = "animated plushies that follow you",
    section = "right",
    flag = "plushies",
    callback = function(r0)
        if r0 then
            u1070.plushies.start()
        else
            u1070.plushies.stop()
        end
    end
}):create_dropdown({
    title = "Plushie Type",
    flag = "plushie_type",
    options = {
        "Reimu",
        "Youmou",
        "Shion",
        "Yuuka",
        "Flandre",
        "Ayanami",
        "Padoru"
    },
    maximum_options = 7,
    multi_dropdown = true,
    callback = function(r0)
        u1070.plushies.active_types = {}

        for r2, r3 in ipairs(r0) do
            u1070.plushies.active_types[r3] = true
        end
    end
})

__S[8]:create_module({
    title = "Field of View",
    description = "changes camera field of view",
    section = "left",
    flag = "fov",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_fov(r0, nil)
    end
}):create_slider({
    title = "FOV",
    flag = "fov_value",
    value = 70,
    minimum_value = 40,
    maximum_value = 120,
    callback = function(r0)
        u1070.player_mods.fov = r0

        if u1070.player_mods.fov_enabled then
            u1062.FieldOfView = r0
        end
    end
})

__S[8]:create_module({
    title = "Speed",
    description = "changes walk speed",
    section = "left",
    flag = "speed",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_speed(r0, nil)
    end
}):create_slider({
    title = "Walk Speed",
    flag = "speed_value",
    value = 16,
    minimum_value = 1,
    maximum_value = 200,
    callback = function(r0)
        u1070.player_mods.speed = r0

        if not u1070.player_mods.speed_enabled then
            return
        end

        local r5 = u1061.Character
        local r2 = r5 and r5:FindFirstChildOfClass("Humanoid")

        if not r2 then
            return
        end

        r2.WalkSpeed = r0
    end
})

__S[8]:create_module({
    title = "Gravity",
    description = "changes workspace gravity",
    section = "right",
    flag = "gravity",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_gravity(r0, nil)
    end
}):create_slider({
    title = "Gravity",
    flag = "gravity_value",
    value = 196,
    minimum_value = 0,
    maximum_value = 500,
    callback = function(r0)
        u1070.player_mods.gravity = r0

        if not u1070.player_mods.gravity_enabled then
            return
        end

        u1058.Gravity = r0
    end
})

__S[8]:create_module({
    title = "Jump Power",
    description = "changes humanoid jump power",
    section = "right",
    flag = "jump_power",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_jump_power(r0, nil)
    end
}):create_slider({
    title = "Jump Power",
    flag = "jump_power_value",
    value = 50,
    minimum_value = 0,
    maximum_value = 300,
    callback = function(r0)
        u1070.player_mods.jump_power = r0

        if not u1070.player_mods.jump_power_enabled then
            return
        end

        local r2 = u1061.Character

        if r2 then
            r2 = r2:FindFirstChildOfClass("Humanoid")
        end

        if r2 then
            r2.JumpPower = r0
        end
    end
})

__S[8]:create_module({
    title = "Infinite Jump",
    description = "allows jumping in mid-air",
    section = "right",
    flag = "infinite_jump",
    notify = true,
    callback = function(r0)
        u1070.player_mods.set_infinite_jump(r0)
    end
})

__S[10]:create_module({
    title = "Avatar Changer",
    description = "copies another player avatar",
    section = "left",
    flag = "avatar_changer",
    callback = function(r0)
        u1070.avatar_changer.enabled = r0

        if r0 then
            u1070.avatar_changer.save_original()

            if u1070.avatar_changer.target ~= "" then
                u1070.avatar_changer.apply(u1070.avatar_changer.target)
            end
        end

        if not r0 and u1070.avatar_changer.applied_id then
            u1070.avatar_changer.restore()
        end
    end
}):create_textbox({
    title = "Username",
    flag = "avatar_target",
    placeholder = "Enter username...",
    callback = function(r0)
        local r2 = u1070.avatar_changer

        if not r0 then
            r0 = ""
        end

        r2.target = r0

        if u1070.avatar_changer.enabled and u1070.avatar_changer.target ~= "" then
            u1070.avatar_changer.applied_id = nil
            u1070.avatar_changer.apply(u1070.avatar_changer.target)
        end
    end
})

__S[10]:create_module({
    title = "Korblox",
    description = "replaces right leg with korblox mesh",
    section = "right",
    flag = "korblox",
    callback = function(r0)
        u1070.avatar.set_korblox(r0)
    end
})

__S[10]:create_module({
    title = "Headless",
    description = "makes head invisible",
    section = "right",
    flag = "headless",
    callback = function(r0)
        u1070.avatar.set_headless(r0)
    end
})

__S[8] = __S[11]:create_module({
    title = "Orbit Ball",
    description = "orbits your character around the ball",
    section = "left",
    flag = "orbit_ball",
    notify = true,
    callback = function(r0)
        if r0 then
            u1070.orbit_ball.start()
        else
            u1070.orbit_ball.stop()
        end
    end
})

__S[8]:create_slider({
    title = "Speed",
    flag = "orbit_speed",
    value = 50,
    minimum_value = 1,
    maximum_value = 200,
    callback = function(r0)
        u1070.orbit_ball.speed = r0
    end
})

__S[8]:create_slider({
    title = "Distance",
    flag = "orbit_distance",
    value = 15,
    minimum_value = 5,
    maximum_value = 60,
    callback = function(r0)
        u1070.orbit_ball.distance = r0
    end
})

__S[8]:create_slider({
    title = "Height",
    flag = "orbit_height",
    value = 5,
    minimum_value = -20,
    maximum_value = 30,
    callback = function(r0)
        u1070.orbit_ball.height = r0
    end
})

__S[9] = __S[11]:create_module({
    title = "Immortality",
    description = "desyncs position while in alive",
    section = "right",
    flag = "walkable_immortal",
    notify = true,
    callback = function(r0)
        if r0 then
            u1070.immortal.start()
        else
            u1070.immortal.stop()
        end
    end
})

__S[9]:create_checkbox({
    title = "Show Visualizer",
    flag = "immortal_visualizer",
    callback = function(r0)
        u1070.immortal.config.visualizer_enabled = r0

        if r0 and u1070.immortal.state.enabled then
            u1070.immortal.create_visualizer()
        elseif not r0 then
            u1070.immortal.destroy_visualizer()
        end
    end
})

__S[9]:create_colorpicker({
    title = "Visualizer Color",
    flag = "immortal_visualizer_color",
    value = u820.fromRGB(255, 0, 0),
    callback = function(r0)
        u1070.immortal.config.visualizer_color = r0
    end
})

__S[9]:create_slider({
    title = "Radius",
    flag = "immortal_radius",
    value = 25,
    minimum_value = 0,
    maximum_value = 100,
    callback = function(r0)
        u1070.immortal.config.radius = r0
    end
})

__S[9]:create_slider({
    title = "Height",
    flag = "immortal_height",
    value = 30,
    minimum_value = 0,
    maximum_value = 60,
    callback = function(r0)
        u1070.immortal.config.height = r0
    end
})

__S[12]:create_module({
    title = "Staff Detection",
    description = "detects if staff members are in your game",
    section = "left",
    flag = "staff_detection",
    callback = function(u1219)
        if u1219 then
            local u1220 = false
            local u1221 = {}
            local u1222 = u799(u796:GetService("TeleportService"))

            local function u1223(u1224)
                if u1221[u1224.UserId] ~= nil then
                    return u1221[u1224.UserId]
                end

                local function r5()
                    local r4 = u1224:IsInGroup(12836673) and u1224:GetRankInGroup(12836673) >= 2
                    return r4
                end

                local r4, r5_2 = pcall(r5)

                if r4 then
                    u1221[u1224.UserId] = r5_2
                    return r5_2
                end

                return false
            end

            local function u1225()
                local r1 = u1054:GetPlayers()
                local r3 = false

                for r1_2, r2 in ipairs(r1) do
                    if u1223(r2) then
                        r3 = true
                        break
                    end

                    r3 = false
                end

                if r3 and not u1220 then
                    u1220 = true

                    if u1070.staff_detection.mode == "Notify" then
                        pcall(function()
                            u864.SendNotification({title = "Staff Detection", text = "Possible staff detected in your game.", duration = 5})
                        end)
                    elseif u1070.staff_detection.mode == "Kick" then
                        pcall(function()
                            u864.SendNotification({title = "Staff Detection", text = "Staff detected. Disconnecting...", duration = 3})
                        end)

                        task.wait(1)
                        u1222:Teleport(u796.PlaceId, u1061)
                    end
                elseif not r3 and u1220 then
                    u1220 = false
                end
            end

            local u1226 = true

            task.spawn(function()
                u1225()

                while u1226 do
                    task.wait(5)

                    if not u1226 then
                        break
                    end

                    u1225()
                end
            end)

            u1069["Staff Detection"] = {
                Disconnect = function()
                    u1226 = false
                end
            }
        elseif u1069["Staff Detection"] then
            u1069["Staff Detection"]:Disconnect()
            u1069["Staff Detection"] = nil
        end
    end
}):create_dropdown({
    title = "Detection Mode",
    flag = "staff_detection_mode",
    options = {"Notify", "Kick"},
    maximum_options = 2,
    multi_dropdown = false,
    callback = function(r0)
        u1070.staff_detection.mode = r0
    end
})

u828.spawn(function()
    task.wait(3)
    u1070.sword_changer.loaded = true

    if u1070.sword_changer.enabled and u1070.sword_changer.update then
        pcall(u1070.sword_changer.update)
    end
end)
end, function(e) return debug.traceback(tostring(e), 2) end, ...)
if not __ok then pcall(warn, "[fatality-port] script error: " .. tostring(__err)) end
