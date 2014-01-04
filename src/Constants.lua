-- Vocation IDs used by $voc
VOC_NONE        = 0
VOC_UNKNOWN     = 0
VOC_NO_VOCATION = 1
VOC_KNIGHT      = 2
VOC_PALADIN     = 4
VOC_SORCERER    = 8
VOC_DRUID       = 16


-- Some useful regexes
REGEX_DMG_TAKEN     = '^You lose (%d+) (%l+) due to an attack by ?a?n? (.-)%.$'
REGEX_DMG_DEALT     = '^A?n? (.+) loses (%d+) (%l+) due to your attack%.$'
REGEX_HEAL_RECEIVED = '^You were healed by (.+) for (%d+) hitpoints%.$'
REGEX_HEAL_SELF     = '^(.+) healed (%l%l%l%l?)self for (%d+) hitpoints%.$'
REGEX_ADVANCE_LVL   = '^You advanced from Level (%d+) to Level (%d+)%.$'
REGEX_ADVANCE_SKILL = '^You advanced to (.-) level (%d+)%.$'
REGEX_LOOT          = '^Loot of ?a?n? (.-): (.+)$'
REGEX_ITEM_CHARGES  = '^You see an? (.-) %(?.- that has (%d+) charges? left%.'
REGEX_ITEM_DURATION = '^You see an? (.-) that will expire in (.-)%.'
REGEX_PLAYER_BASIC  = '^You see (.-) %(Level (%d+)%)%. (%a+) is an? (.-)%.'
REGEX_PLAYER_FULL   = REGEX_PLAYER_BASIC .. ' %u%l%l? is (.-) of the (.+), which has (%d+) members, (%d+) of them online%.$'
REGEX_SERVER_SAVE   = '^Server is saving game in (%d+) minutes. Please .+%.$'
REGEX_SPA_COORDS    = '^x:(%d+), y:(%d+), z:(%d+)$'
REGEX_SPA_SIZE      = '^(%d+) x (%d+)$'


-- Custom Types properties
CUSTOM_TYPE = {
	CREATURE     = {'name', 'id', 'hppc', 'posx', 'posy', 'posz', 'dir', 'speed', 'iswalking', 'outfit', 'headcolor', 'chestcolor', 'legscolor', 'feetcolor', 'addon', 'mount', 'lightintensity', 'lightcolor', 'lastattacked', 'walkblock', 'skull', 'party', 'warbanner', 'updated', 'aggressortype', 'isshootable', 'isreachable', 'dist', 'ignored', 'ismonster', 'isplayer', 'isnpc', 'issummon', 'isownsummon', 'hpcolor'},
	ITEM         = {'id', 'count', 'special'},
	CONTAINER    = {'name', 'itemid', 'itemcount', 'maxcount', 'isopen', 'ispage', 'hashigher'},
	TILE         = {'itemcount'},
	MESSAGE      = {'content', 'level', 'sender', 'type'},
	PROJECTILE   = {'type', 'fromx', 'fromy', 'tox', 'toy', 'time'},
	EFFECT       = {'type', 'posx', 'posy', 'time'},
	ANIMTEXT     = {'type', 'content', 'posx', 'posy', 'time'},
	RECT         = {'left', 'top', 'bottom', 'right', 'width', 'height', 'centerx', 'centery'},
	POINT        = {'x', 'y'},
	ITEMDATA     = {'name', 'id', 'sellprice', 'buyprice', 'weight', 'isbank', 'isclip', 'isbottom', 'istop', 'iscontainer', 'iscumulative', 'isforceuse', 'ismultiuse', 'iswrite', 'iswriteonce', 'isliquidcontainer', 'isliquidpool', 'isunpass', 'isunmove', 'isunsight', 'isavoid', 'isnomovementanimation ', 'istake', 'ishang', 'ishooksouth', 'ishookeast', 'isrotate', 'islight', 'isdonthide', 'istranslucent', 'isfloorchange', 'isshift', 'isheight', 'islyingobject', 'isanimatealways', 'isautomap', 'islenshelp', 'isfullbank', 'isignorelook', 'isclothes', 'ismarket', 'ismount', 'isdefaultaction', 'isusable', 'ignoreextradata', 'enchantable', 'destructible', 'hasextradata', 'height', 'sizeinpixels', 'layers', 'patternx', 'patterny', 'patterndepth', 'phase', 'walkspeed', 'textlimit', 'lightradius', 'lightcolor', 'shiftx', 'shifty', 'walkheight', 'automapcolor', 'lenshelp', 'defaultaction', 'clothslot', 'marketcategory', 'markettradeas', 'marketshowas', 'marketrestrictprofession', 'marketrestrictlevel', 'durationtotalinmsecs', 'specialeffect', 'specialeffectgain', 'category', 'attack', 'attackmod', 'hitpercentmod', 'defense', 'defensemod', 'armor', 'holyresistmod', 'deathresistmod', 'earthresistmod', 'fireresistmod', 'iceresistmod', 'energyresistmod', 'physicalresistmod', 'lifedrainresistmod', 'manadrainresistmod', 'itemlossmod', 'mindmg', 'maxdmg', 'dmgtype', 'range', 'mana'},
	SUPPLYDATA   = {'name', 'id', 'weight', 'buyprice', 'leaveat', 'count', 'rule', 'rulevalue', 'destination', 'category', 'uptocount', 'downtocap', 'amountbought', 'amounttobuy', 'amountused'},
	LOOTINGDATA  = {'name' ,'id' ,'weight' ,'sellprice' ,'count' ,'action' ,'alert' ,'condition' ,'conditionvalue' ,'destination' ,'category' ,'amountlooted' ,'haslessthan' ,'caphigherthan'},
	VIP          = {'name', 'id', 'icon', 'isonline', 'notify'},
	MOUSEINFO    = {'x', 'y', 'z', 'id', 'count'},
	DEATHTIMER   = {'timeofdeath', 'target', 'killer', 'time'},
	PLAYERINFO   = {'name', 'guild', 'voc', 'vocation', 'vocshort', 'priority', 'status', 'time', 'level', 'comment'},
	NAVPING      = {'time', 'color', 'glowcolor', 'posx', 'posy', 'posz'},
	NAVTARGET    = {'name', 'posx', 'posy', 'posz', 'time', 'color', 'glowcolor', 'isleader', 'isfriend', 'isenemy', 'isneutral', 'team', 'teamname', 'creature', 'realname', 'id', 'mp', 'maxmp', 'voc', 'icon'}
}


-- Key codes
-- http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
local KEYS = {
	MOUSELEFT   = 0x01,
	MOUSERIGHT  = 0x02,
	MOUSEMIDDLE = 0x04,
	BACKSPACE   = 0x08,
	TAB         = 0x09,
	CLEAR       = 0x0C,
	ENTER       = 0x0D,
	SHIFT       = 0x10,
	CTRL        = 0x11,
	ALT         = 0x12,
	PAUSE       = 0x13,
	CAPSLOCK    = 0x14,
	ESC         = 0x1B,
	SPACE       = 0x20,
	PAGEUP      = 0x21,
	PAGEDOWN    = 0x22,
	END         = 0x25,
	HOME        = 0x24,
	LEFTARROW   = 0x25,
	UPARROW     = 0x26,
	RIGHTARROW  = 0x27,
	DOWNARROW   = 0x28,
	SELECT      = 0x29,
	PRINT       = 0x2A,
	EXECUTE     = 0x2B,
	PRINTSCREEN = 0x2C,
	INSERT      = 0x2D,
	DELETE      = 0x2E,
	HELP        = 0x2F,

	['0']       = 0x30,
	['1']       = 0x31,
	['2']       = 0x32,
	['3']       = 0x33,
	['4']       = 0x34,
	['5']       = 0x35,
	['6']       = 0x36,
	['7']       = 0x37,
	['8']       = 0x38,
	['9']       = 0x39,

	A           = 0x41,
	B           = 0x42,
	C           = 0x43,
	D           = 0x44,
	E           = 0x45,
	F           = 0x46,
	G           = 0x47,
	H           = 0x48,
	I           = 0x49,
	J           = 0x4A,
	K           = 0x4B,
	L           = 0x4C,
	M           = 0x4D,
	N           = 0x4E,
	O           = 0x4F,
	P           = 0x50,
	Q           = 0x51,
	R           = 0x52,
	S           = 0x53,
	T           = 0x54,
	U           = 0x55,
	V           = 0x56,
	W           = 0x57,
	x           = 0x58,
	Y           = 0x59,
	Z           = 0x5A,

	SLEEP       = 0x5F,
	NUM0        = 0x60,
	NUM1        = 0x61,
	NUM2        = 0x62,
	NUM3        = 0x63,
	NUM4        = 0x64,
	NUM5        = 0x65,
	NUM6        = 0x66,
	NUM7        = 0x67,
	NUM8        = 0x68,
	NUM9        = 0x69,
	MULTIPLY    = 0x6A,
	ADD         = 0x6B,
	SEPARATOR   = 0x6C,
	SUBTRACT    = 0x6D,
	DECIMAL     = 0x6E,
	DIVIDE      = 0x6F,

	F1          = 0x70,
	F2          = 0x71,
	F3          = 0x72,
	F4          = 0x73,
	F5          = 0x74,
	F6          = 0x75,
	F7          = 0x76,
	F8          = 0x77,
	F9          = 0x78,
	F10         = 0x89,
	F11         = 0x7A,
	F12         = 0x7B,
	F13         = 0x7C,
	F14         = 0x7D,
	F15         = 0x7E,
	F16         = 0x7F,
	F17         = 0x80,
	F18         = 0x81,
	F19         = 0x82,
	F20         = 0x83,
	F21         = 0x84,
	F22         = 0x85,
	F23         = 0x86,
	F24         = 0x87,

	NUMLOCK     = 0x90,
	SCROLLLOCK  = 0x91,
	COMMA       = 0xBC,
	HIFFEN      = 0xBD,
	DOT         = 0xBE,
	BAR         = 0xBF,
	SINGLEQUOTE = 0xD3
}