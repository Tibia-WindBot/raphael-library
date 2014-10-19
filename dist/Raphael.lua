-- Raphael's Library v1.4.0
-- Last Updated: 19/10/2014 - 22:26 UTC
-- Released for WindBot v2.4.9

RAPHAEL_LIB = '1.4.0'

--[[
 * Changelog v1.4.0
 *
 * - Added table.flatten.
 * - Added getvalue and curchannel.
 * - Added Expander Class.
 * - Added composition mode constants.
 * - Added REGEX_ITEMS_SOLD and REGEX_ITEMS_BOUGHT.
 * - Updated cetoffset and cettime; this should fix problems with sstime.
 * - Updated npctalk to better emulate time taken to write message when fast hotkeys is enabled.
 * - Updated table.each and table.map to allow for recursive behavior.
 * - Updated table.merge to allow for recursive behavior and remove forceKey parameter.
 * - Updated Area Class to include extra functionality.
 * - Fixed some other minor bugs.
 *
--]]

LIBS = LIBS or {}
LIBS.RAPHAEL = RAPHAEL_LIB


-- Setting a good random seed
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)) * (os.clock()) * $idlerecvtime / $timems + ($connected and 1 or 0))

-- Make sure table.unpack and unpack are both mapped to the same function
table.unpack = table.unpack or unpack
unpack = unpack or table.unpack

-- Handle overwrriten functions
_TIMETOLEVEL = _TIMETOLEVEL or timetolevel
_TOSTRING    = _TOSTRING    or tostring
_TYPE        = _TYPE        or type
math._CEIL   = math._CEIL   or math.ceil
math._FLOOR  = math._FLOOR  or math.floor

-- Global object to keep track of stuff by our functions
_Tracker = _Tracker or {}

-- Composition modes; BECAUSE CONSTANTS SHOULD BE IN ALL CAPS
COMPOSITION_AUTOMATIC        = CompositionMode_Automatic
COMPOSITION_SOURCE           = CompositionMode_Source
COMPOSITION_DESTINATION      = CompositionMode_Destination
COMPOSITION_SOURCE_OVER      = CompositionMode_Source_Over
COMPOSITION_DESTINATION_OVER = CompositionMode_DestinationOver
COMPOSITION_SOURCE_IN        = CompositionMode_SourceIn
COMPOSITION_DESTINATION_IN   = CompositionMode_DestinationIn
COMPOSITION_SOURCE_OUT       = CompositionMode_SourceOut
COMPOSITION_DESTINATION_OUT  = CompositionMode_DestinationOut
COMPOSITION_SOURCE_ATOP      = CompositionMode_SourceAtop
COMPOSITION_DESTINATION_ATOP = CompositionMode_DestinationAtop
COMPOSITION_CLEAR            = CompositionMode_Clear
COMPOSITION_XOR              = CompositionMode_Xor


-- Items bought by npcs
ITEMS_ASNARUS     = {283, 284, 285, 2874, 3277, 3349, 3350, 20183, 20184, 20198, 20199, 20200, 20201, 20202, 20203, 20204, 20205, 20206, 20207}
ITEMS_BLUE_DJINN  = {660, 674, 679, 693, 779, 793, 794, 810, 3046, 3049, 3050, 3056, 3060, 3061, 3062, 3071, 3072, 3073, 3074, 3075, 3079, 3081, 3082, 3083, 3091, 3092, 3093, 3271, 3279, 3280, 3284, 3301, 3302, 3313, 3320, 3380, 3381, 3382, 3385, 3391, 3392, 3415, 3416, 3418, 3419, 3439, 3567, 7391, 7410, 7412, 7436, 7451, 7454, 8092, 8093, 8094, 16096, 16115}
ITEMS_ESRIK       = {3264, 3265, 3266, 3267, 3268, 3269, 3270, 3272, 3273, 3274, 3275, 3276, 3282, 3283, 3285, 3286, 3293, 3294, 3298, 3300, 3304, 3305, 3316, 3336, 3337, 3338, 3351, 3352, 3353, 3354, 3355, 3357, 3358, 3359, 3361, 3362, 3367, 3372, 3374, 3375, 3376, 3377, 3378, 3379, 3409, 3410, 3411, 3412, 3413, 3425, 3426, 3430, 3431, 3462, 3552, 3557, 3558, 3559, 3561, 3562, 4033, 10323, 10384, 10385, 10386, 10387, 10388, 10389, 10390, 10391, 10392, 10404, 10405, 10406, 10408, 10410, 10412, 10414, 10416, 10418, 11651, 11657, 11659, 11660, 11661, 17824}
ITEMS_FIONA       = {5879, 5881, 5882, 5884, 5885, 5890, 5891, 5893, 5894, 5895, 5898, 5899, 5902, 5904, 5905, 5906, 5920, 5921, 5922, 5925, 5930, 5954, 7439, 7440, 7443, 9053, 9054, 9055, 9636, 9642, 9644, 9647, 9649, 9660, 9661, 9665, 9666, 10275, 10276, 10277, 10278, 10280, 10304, 10312, 10397, 10444, 11454, 11457, 11463, 11464, 11465, 11474, 11512, 11658, 11702, 11703, 14008, 14009, 14013, 16131, 16139, 16140, 17809, 17817, 17826, 17827, 17831, 17847, 17848, 17849, 17850, 17851, 17853, 17854, 17855, 17856, 17857, 18928}
ITEMS_GREEN_DJINN = {666, 685, 785, 802, 3045, 3048, 3051, 3052, 3053, 3054, 3065, 3066, 3067, 3069, 3070, 3077, 3078, 3084, 3085, 3097, 3098, 3281, 3297, 3299, 3307, 3318, 3322, 3324, 3369, 3370, 3371, 3373, 3383, 3384, 3428, 3429, 3432, 3434, 3574, 7407, 7411, 7413, 7419, 7421, 7428, 8082, 8083, 8084, 16117, 16118}
ITEMS_GRIZZLY     = {7393, 7394, 7396, 7397, 7398, 7399, 7400, 7401, 9631, 9633, 9648, 9657, 9662, 10244, 10272, 10273, 10282, 10297, 10311, 10398, 10419, 10421, 10452, 10454, 10455, 10456, 11487, 11488, 11489, 11490, 11491, 11514, 11539, 12039, 12040, 12172, 12309, 12312, 12313, 12314, 12315, 12316, 12317, 17461, 17462, 17818, 18993, 18994}
ITEMS_IRMANA      = {3568, 5876, 5877, 5878, 5883, 5886, 5909, 5910, 5911, 5912, 5913, 5914, 5948, 8923, 9045, 9658, 9684, 9689, 9690, 9691, 9694, 10274, 10279, 10292, 10293, 10295, 10299, 10307, 10317, 10318, 10319, 10407, 11448, 11456, 11458, 11470, 11473, 11475, 11486, 11492, 11493, 11684, 17819}
ITEMS_MALUNGA     = {8031, 8143, 9634, 9637, 9640, 9641, 9643, 9651, 9659, 9663, 9667, 9668, 9683, 9693, 10281, 10283, 10291, 10301, 10306, 10308, 10309, 10313, 10411, 10420, 10449, 10450, 11446, 11467, 11475, 11481, 11484, 11485, 11513, 11666, 11671, 11672, 11673, 11680, 12541, 12601, 12730, 12742, 12805, 14011, 14012, 14017, 14041, 14044, 14076, 14078, 14079, 14080, 14081, 14082, 14083, 16132, 16134, 17458, 17463, 17822, 17823, 17830, 18924, 18925, 18926, 18927, 18929, 18930, 18995, 18996, 18997, 19110, 19111}
ITEMS_TAMORIL     = {2903, 3036, 3037, 3038, 3039, 3041}
ITEMS_TELAS       = {5887, 5888, 5889, 5892, 8775, 9027, 9028, 9063, 9064, 9065, 9066, 9067, 9632, 9654, 9655, 9656, 9664, 10298, 10310, 10315, 11447, 12600, 12806, 16130, 16133, 16135, 16137, 16138}
ITEMS_RASHID      = {661, 662, 664, 667, 668, 669, 672, 673, 680, 681, 682, 683, 686, 687, 688, 691, 692, 780, 781, 783, 786, 787, 788, 791, 792, 795, 796, 798, 803, 804, 805, 808, 809, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 2958, 2991, 3002, 3006, 3007, 3008, 3010, 3016, 3017, 3018, 3019, 3025, 3055, 3063, 3290, 3314, 3315, 3326, 3327, 3328, 3330, 3332, 3333, 3334, 3339, 3340, 3342, 3344, 3356, 3360, 3364, 3366, 3386, 3397, 3404, 3408, 3414, 3420, 3421, 3435, 3436, 3440, 3441, 3442, 3550, 3554, 3556, 5461, 5710, 5741, 5810, 5917, 5918, 6095, 6096, 6131, 6299, 6553, 7379, 7380, 7381, 7382, 7383, 7384, 7386, 7387, 7388, 7389, 7390, 7392, 7402, 7403, 7404, 7406, 7408, 7414, 7415, 7418, 7422, 7424, 7425, 7426, 7427, 7429, 7430, 7432, 7434, 7437, 7438, 7449, 7452, 7456, 7457, 7460, 7461, 7462, 7463, 7464, 8022, 8027, 8045, 8049, 8050, 8052, 8057, 8061, 8063, 9013, 9014, 9015, 9017, 9302, 9303, 9304, 9653, 10457, 11674, 12683, 16163, 16164, 17828, 17829, 17852}
ITEMS_YASIR       = {647, 2933, 3044, 3058, 3735, 3736, 3741, 5479, 5804, 5809, 5875, 5876, 5877, 5878, 5879, 5880, 5881, 5882, 5883, 5884, 5885, 5890, 5891, 5893, 5894, 5895, 5896, 5897, 5898, 5899, 5901, 5902, 5904, 5905, 5906, 5909, 5910, 5911, 5912, 5913, 5914, 5919, 5920, 5921, 5922, 5925, 5930, 5948, 5954, 6491, 6525, 6534, 6535, 6536, 6537, 6539, 6540, 6546, 8031, 8143, 9035, 9053, 9054, 9055, 9631, 9633, 9634, 9635, 9636, 9637, 9638, 9639, 9640, 9641, 9642, 9643, 9644, 9645, 9646, 9647, 9648, 9649, 9650, 9651, 9652, 9657, 9658, 9659, 9660, 9661, 9662, 9663, 9665, 9666, 9667, 9668, 9683, 9684, 9685, 9686, 9688, 9689, 9690, 9691, 9692, 9693, 9694, 10196, 10272, 10273, 10274, 10275, 10276, 10277, 10278, 10279, 10280, 10281, 10282, 10283, 10291, 10292, 10293, 10295, 10296, 10297, 10299, 10300, 10301, 10302, 10303, 10304, 10305, 10306, 10307, 10308, 10309, 10311, 10312, 10313, 10314, 10316, 10317, 10318, 10319, 10320, 10321, 10397, 10404, 10405, 10407, 10408, 10409, 10410, 10411, 10413, 10414, 10415, 10416, 10417, 10418, 10420, 10444, 10449, 10450, 10452, 10453, 10454, 10455, 10456, 11443, 11444, 11445, 11446, 11448, 11449, 11450, 11451, 11452, 11453, 11454, 11455, 11456, 11457, 11458, 11463, 11464, 11465, 11466, 11467, 11469, 11470, 11471, 11472, 11473, 11474, 11475, 11476, 11477, 11478, 11479, 11480, 11481, 11482, 11483, 11484, 11485, 11486, 11487, 11488, 11489, 11490, 11491, 11492, 11493, 11510, 11511, 11512, 11513, 11514, 11515, 11539, 11652, 11658, 11659, 11660, 11661, 11666, 11671, 11672, 11673, 11680, 11684, 11702, 11703, 12541, 12730, 12737, 12742, 14008, 14009, 14010, 14011, 14012, 14013, 14017, 14041, 14044, 14076, 14077, 14078, 14079, 14080, 14081, 14082, 14083, 14225, 16131, 16132, 16134, 16139, 16140, 17458, 17461, 17462, 17463, 17809, 17817, 17818, 17819, 17822, 17823, 17826, 17827, 17830, 17831, 17847, 17848, 17849, 17850, 17851, 17853, 17854, 17855, 17856, 17857, 18924, 18925, 18926, 18927, 18928, 18929, 18930, 18993, 18994, 18995, 18996, 18997, 19110, 19111, 20183, 20184, 20199, 20200, 20201, 20202, 20203, 20204, 20205, 20206, 20207}


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
REGEX_SERVER_SAVE   = '^Server is saving game in (%d+) minutes?. Please .+%.$'
REGEX_COORDS        = '^x:(%d+), y:(%d+), z:(%d+)$'
REGEX_RANGE         = '^(%d+) x (%d+)$'
REGEX_ITEMS_SOLD    = '^Sold (%d+)x (.-) for (%d+) gold%.$'
REGEX_ITEMS_BOUGHT  = '^Bought (%d+)x (.-) for (%d+) gold%.$'

-- Deprecated regexes
REGEX_SPA_COORDS = REGEX_COORDS
REGEX_SPA_SIZE   = REGEX_RANGE


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
	ITEMDATA     = {'name', 'id', 'sellprice', 'buyprice', 'weight', 'isbank', 'isclip', 'isbottom', 'istop', 'iscontainer', 'iscumulative', 'isforceuse', 'ismultiuse', 'iswrite', 'iswriteonce', 'isliquidcontainer', 'isliquidpool', 'isunpass', 'isunmove', 'isunsight', 'isavoid', 'isnomovementanimation', 'istake', 'ishang', 'ishooksouth', 'ishookeast', 'isrotate', 'islight', 'isdonthide', 'istranslucent', 'isfloorchange', 'isshift', 'isheight', 'islyingobject', 'isanimatealways', 'isautomap', 'islenshelp', 'isfullbank', 'isignorelook', 'isclothes', 'ismarket', 'ismount', 'isdefaultaction', 'isusable', 'ignoreextradata', 'enchantable', 'destructible', 'hasextradata', 'height', 'sizeinpixels', 'layers', 'patternx', 'patterny', 'patterndepth', 'phase', 'walkspeed', 'textlimit', 'lightradius', 'lightcolor', 'shiftx', 'shifty', 'walkheight', 'automapcolor', 'lenshelp', 'defaultaction', 'clothslot', 'marketcategory', 'markettradeas', 'marketshowas', 'marketrestrictprofession', 'marketrestrictlevel', 'durationtotalinmsecs', 'specialeffect', 'specialeffectgain', 'category', 'attack', 'attackmod', 'hitpercentmod', 'defense', 'defensemod', 'armor', 'holyresistmod', 'deathresistmod', 'earthresistmod', 'fireresistmod', 'iceresistmod', 'energyresistmod', 'physicalresistmod', 'lifedrainresistmod', 'manadrainresistmod', 'itemlossmod', 'mindmg', 'maxdmg', 'dmgtype', 'range', 'mana'},
	SUPPLYDATA   = {'name', 'id', 'weight', 'buyprice', 'leaveat', 'count', 'rule', 'rulevalue', 'destination', 'category', 'uptocount', 'downtocap', 'amountbought', 'amounttobuy', 'amountused'},
	LOOTINGDATA  = {'name' ,'id' ,'weight' ,'sellprice' ,'count' ,'action' ,'alert' ,'condition' ,'conditionvalue' ,'destination' ,'category' ,'amountlooted' ,'haslessthan' ,'caphigherthan'},
	VIP          = {'name', 'id', 'icon', 'isonline', 'notify'},
	MOUSEINFO    = {'x', 'y', 'z', 'id', 'count', 'crosshair'},
	DEATHTIMER   = {'timeofdeath', 'target', 'killer', 'time'},
	PLAYERINFO   = {'name', 'guild', 'voc', 'vocation', 'vocshort', 'priority', 'status', 'time', 'level', 'comment'},
	NAVPING      = {'time', 'color', 'glowcolor', 'posx', 'posy', 'posz'},
	NAVTARGET    = {'name', 'posx', 'posy', 'posz', 'time', 'color', 'glowcolor', 'isleader', 'isfriend', 'isenemy', 'isneutral', 'team', 'teamname', 'creature', 'realname', 'id', 'mp', 'maxmp', 'voc', 'icon'}
}


-- Key codes
-- http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
-- CAUTION: This list if fucked up, for some reason
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





--[[
 * Gets the variable's type. Works for user created classes, using
 * getclasses().
 *
 * @since     0.1.0
 * @overrides
 *
 * @param     {any}          value          - The variable to be checked
 *
 * @returns   {string}                      - The variable's type
--]]
function type(value)
	local luaType = _TYPE(value)

	-- If it's not an object, simply return the actual variable type
	if luaType ~= 'table' then
		return luaType
	end

	return value.__class or luaType
end

--[[
 * Compares version strings.
 *
 * Receives two version strings, compares them and return a boolean indicating
 * whether v1 is equal to or higher than v2.
 *
 * @since     0.1.0
 *
 * @param     {string}       v1             - The version string to be checked
 * @param     {string}       v2             - The version it should be compared
 *                                            with
 *
 * @returns   {boolean}                     - Whether v1 is equal or higher
 *                                            than v2
--]]
function versionhigherorequal(v1, v2)
	local v1, v2 = string.explode(tostring(v1), '%.'), string.explode(tostring(v2), '%.')
	for i = 1, math.max(#v1, #v2) do
		v1[i] = tonumber(v1[i]) or 0
		v2[i] = tonumber(v2[i]) or 0
		if v1[i] < v2[i] then
			return false
		elseif v1[i] > v2[i] then
			return true
		end
	end
	return true
end

--[[
 * Executes a given string and returns its return values.
 *
 * @since     0.1.0
 *
 * @param     {string}       code           - The string to be executed
 *
 * @returns   {any}                         - Anything returned by the code ran
--]]
function exec(code)
        local func = loadstring(code)

        -- Needs pcall to be reenabled
        -- local arg = {pcall(func)}
        -- table.insert(arg, arg[1])
        -- table.remove(arg, 1)
        -- return table.unpack(arg)

        return func()
end

--[[
 * Calculates the total experience at specified level.
 *
 * @since     0.1.0
 *
 * @param     {number}       level          - The starting level
 *
 * @returns   {number}                      - The experience needed
--]]
function expatlvl(level)
	return 50 / 3 * (level ^ 3 - 6 * level ^ 2 + 17 * level - 12)
end

--[[
 * Gets the variable's classes, looking for the __class index on their
 * metatables.
 *
 * @since     0.1.0
 *
 * @param     {any}          value          - The variable to be checked
 *
 * @returns   {string...}                   - The variable's classes
--]]
function getclasses(value)
	local classes = {}

	local meta = getmetatable(value)
	while meta and meta.__index do
		if meta.__index.__class then
			table.insert(classes, meta.__index.__class)
		end

		meta = getmetatable(meta.__index)
	end

	return table.unpack(classes)
end

--[[
 * Gets the total amount of visible gold you're carrying.
 *
 * @since     0.1.0
 * @updated   1.2.0
 *
 * @param     {string}       [coin]         - Coin type to consider; defaults to
 *                                          - all
 * @param     {string}       [location]     - Where to look for gold; defaults
 *                                          - to any
 *
 * @returns   {number}                      - Total amount of gold
--]]
function gold(coin, location)
	local coins = {'gold coin', 'platinum coin', 'crystal coin'}

	-- Allows us to count only a specific coin type
	if coin and table.find(coins, coin:lower()) then
		coins = {coin}
	else
		location = coin
	end

	local totalGold = 0
	for _, v in ipairs(coins) do
		totalGold = totalGold + itemcount(v, location) * itemvalue(v)
	end

	return totalGold
end

--[[
 * Gets the total amount of visible flasks you're carrying.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - Total amount of flasks
--]]
function flasks()
	return itemcount('empty potion flask (small)') +
	       itemcount('empty potion flask (medium)') +
	       itemcount('empty potion flask (large)')
end

--[[
 * Helper for the ternary operator that Lua lacks. Returns `expr2` if `expr1`
 * is true, `expr3` otherwise.
 *
 * @since     0.1.0
 *
 * @param     {any}          expr1          - The expression to be evaluated
 * @param     {any}          expr2          - The expression to be returned if
 *                                            `expr1` evaluates to true
 * @param     {any}          expr3          - The expression to be returned if
 *                                            `expr1` evaluates to false
 *
 * @returns   {any}                         - `expr2` or `expr3`
--]]
function tern(expr1, expr2, expr3)
	if expr1 then
		return expr2
	else
		return expr3
	end
end

--[[
 * Returns the maximum capacity for the character current logged on. It may
 * get it wrong if you left rookgard after level 8.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - Maximum capacity
--]]
function maxcap()
	-- There's no way to know max cap if we're not logged in
	if $voc == 0 then
		return -1
	end

	local vocs = {10, 30, 20, 10, 10}
	return vocs[math.log($voc * 2, 2)] * ($level - 8) + 470
end

--[[
 * Returns the amount of seconds the computer's clock is currently offset from
 * UTC timezone.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - UTC offset in seconds
--]]
function utcoffset()
	local now = os.time()
	return os.difftime(
		now,
		os.time(os.date("!*t", now)) - tern(os.date('*t').isdst, 3600, 0)
	)
end

--[[
 * Returns the amount of seconds the computer's clock is currently offset from
 * CET timezone.
 *
 * @since     0.1.0
 * @updated   1.4.0
 *
 * @returns   {number}                      - CET offset in seconds
--]]
function cetoffset()
	-- List taken from http://www.timeanddate.com/time/zone/germany/frankfurt
	local daylightDates = {
		[2013] = {90, 300},
		[2014] = {89, 299},
		[2015] = {88, 298},
		[2016] = {87, 304},
		[2017] = {85, 302}
	}

	local now = os.date('!*t')
	local daylightDate = daylightDates[now.year]

	return utcoffset() + tern(now.yday >= daylightDate[1] and now.yday <= daylightDate[2], 7200, 3600)
end

--[[
 * Returns the current time of day, in seconds, on UTC timezone.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - UTC time of day in seconds
--]]
function utctime()
	return tosec(os.date('!%X'))
end

--[[
 * Returns the current time of day, in seconds, on CET timezone.
 *
 * @since     0.1.0
 * @updated   1.4.0
 *
 * @returns   {number}                      - CET time of day in seconds
--]]
function cettime()
	return utctime() - utcoffset() + cetoffset()
end

--[[
 * Returns the current computers timezone string. Ex: UTC +3
 *
 * @since     0.1.0
 *
 * @returns   {string}                      - Computer's timezone
--]]
function timezone()
	local offset = utcoffset()
	if offset then
		return 'UTC ' .. tern(offset > 0, '+', '-') .. math.abs(offset / 3600)
	end
	return 'UTC'
end

--[[
 * Returns amount of seconds left for the next server save.
 *
 * @since     0.1.0
 *
 * @returns   {number}                      - Seconds left to server save
--]]
function sstime()
	return (36000 - cettime()) % 86400
end

--[[
 * Shorthand method for playing a beep.
 *
 * @since     0.1.0
--]]
function beep()
	playsound('monster.wav')
end

--[[
 * Shorthand method for not listing a hotkey.
 *
 * @since     0.1.0
--]]
function dontlist()
	listas('dontlist')
end

--[[
 * Returns all the open containers' objects.
 *
 * @since     0.1.0
 *
 * @return    {array}                       - The containers' objects
--]]
function getopencontainers()
	local conts, c = {}
	for i = 0, 15 do
		c = getcontainer(i)
		if c.isopen then
			table.insert(conts, c)
		end
	end

	return conts
end

--[[
 * Toggles a setting. If it's set to `a`, sets it to `b` and the other way
 * around.
 *
 * @since     0.1.1
 *
 * @param     {string}       setting        - The setting to be toggled
 * @param     {string}       a              - One of the values used on toggle
 * @param     {string}       b              - The other value used on toggle
--]]
function toggle(setting, a, b)
	a, b = a or 'no', b or 'yes'
	set(setting, tern(get(setting) == a, b, a))
end

--[[
 * Converts any variable to a boolean representation.
 *
 * @since     0.1.1
 * @updated   1.0.0
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {boolean}                     - Boolean representation
--]]
function tobool(value, strict)
	strict = strict or false

	local valType = type(value)

	if valType == 'boolean' then
		return value
	elseif valType == 'nil' then
		return false
	elseif valType == 'userdata' then
		return true
	elseif valType == 'number' then
		return value ~= 0
	elseif valType == 'string' then
		return tobool(#value) and (strict or not (value == 'no' or value == 'off'))
	elseif valType == 'table' then
		return table.size(value) == 0
	end
end

--[[
 * Converts any variable to a numeric representation; that means one or zero.
 *
 * @since     1.0.0
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {number}                      - Numeric representation
--]]
function toonezero(value, strict)
	return tern(tobool(value, strict), 1, 0)
end

--[[
 * Converts any variable to a yes/no representation.
 *
 * @since     1.0.0
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {string}                      - Yes/no representation
--]]
function toyesno(value, strict)
	return tern(tobool(value, strict), 'yes', 'no')
end

--[[
 * Converts any variable to a on/off representation.
 *
 * @since     1.0.0
 *
 * @param     {any}          value          - The value to be converted
 * @param     {string}       property       - Whether the conversion should be
 *                                            strict; this means 'no' and 'off'
 *                                            are considered true.
 *
 * @return    {string}                      - On/off representation
--]]
function toonoff(value, strict)
	return tern(tobool(value, strict), 'on', 'off')
end

--[[
 * Verifies that certain requirements, such as libraries and bot version, are
 * met. Throws an error if it doesn't.
 *
 * @since     1.0.0
 *
 * @param     {table}        reqs           - Requirements in a table, in the
 *                                            pattern of {curVer, neededVer,
 *                                            reqName}
--]]
function requires(reqs)
	local failedRequirements = {}

	for _, v in ipairs(reqs) do
		if not versionhigherorequal(v[1], v[2]) then
			table.insert(failedRequirements, v)
		end
	end

	if #failedRequirements > 0 then
		local errorMsg = 'Your current setup does not meet the following ' ..
		                 'minimum requirements:\n'

		for _, v in ipairs(failedRequirements) do
			errorMsg = errorMsg .. '\n' ..
			           '- ' .. v[3] .. ': v' .. v[2]
		end

		printerror(errorMsg)
	end
end

--[[
 * Converts a userdata into a string reprensentation.
 *
 * @since     1.0.0
 * @updated   1.1.0
 *
 * @param     {userdata}     userdata       - The userdata to be converted
 *
 * @returns   {string}                      - The String reprensentation
--]]
function userdatastringformat(userdata)
	local obj = {}
	local props = CUSTOM_TYPE[userdata.objtype:upper()]

	for _, v in ipairs(props) do
		obj[v] = userdata[v]
	end

	if userdata.objtype == 'tile' or userdata.objtype == 'container' then
		obj.item = {}

		for i = 1, userdata.itemcount do
			table.insert(obj.item, userdata.item[i])
		end
	end

	return table.stringformat(obj)
end

--[[
 * Converts any value into a string. Handles tables and userdatas specially.
 *
 * @since     1.0.0
 * @overrides
 *
 * @param     {any}          value          - The variable to be converted
 *
 * @returns   {string}                      - The converted value
--]]
function tostring(value)
	if type(value) == 'table' then
		return table.stringformat(value)
	elseif type(value) == 'userdata' then
		return userdatastringformat(value)
	else
		return _TOSTRING(value)
	end
end

--[[
 * Calls the firs item in the t table passing the other items as arguments.
 * Optionally, extra arguments can be included by passing them after the table;
 * these are passed as arguments before the items of the array.
 *
 * @since     1.1.0
 *
 * @param     {table}        t              - The table with the function to be
 *                                            called and its arguments
 * @param     {any}          [...]          - Extra arguments
 *
 * @returns   {string}                      - The converted value
--]]
function calltable(t, ...)
	local f = t[1]
	local args = {...}
	for i = 2, #t do
		table.insert(args, i - 1, t[i])
	end

	return f(table.unpack(args))
end

--[[
 * Waits until a condition is satisfied for a maximum time of `time`. Condition
 * must be passed as the `f` argument and any extra parameters and be passed as
 * a table, as the `fArgs` parameter. If the condition fulfills in the given
 * time, true is returned, else false.
 *
 * @since     1.1.0
 *
 * @param     {function}     f              - The condition function
 * @param     {number}       time           - The maximum time to wait in ms
 * @param     {table}        [fArgs]        - Arguments for the `f` condition
 *
 * @returns   {boolean}                     - Whether the condition was
 *                                            fulfilled or not
--]]
function waitcondition(f, time, fArgs)
	fArgs = fArgs or {}

	local t = math.round(time / 100)
	for i = 1, t do
		if f(table.unpack(fArgs)) then
			return true
		end

		wait(100)
	end

	return false
end

--[[
 * Given a waypoint's label, gives its ID. Only works on the current section. If
 * no waypoint with that label is found, nothing is returned.
 *
 * @since     1.2.0
 *
 * @param     {string}       label          - The waypoint's label
 *
 * @returns   {number}                      - The waypoint's ID
--]]
function getwptid(label)
	local id = 0
	foreach settingsentry s 'Cavebot/Waypoints' do
		if get(s, 'Label') == label then
			return id
		end

		id = id + 1
	end
end

--[[
 * Calculates the amount of time needed to advance to the specified level, if
 * the current experience rate is kept. If `extraPrecision` is enabled, the time
 * is returned in seconds, otherwise, in minutes.
 *
 * @since     1.3.0
 * @overrides
 *
 * @param     {boolean}     [extraPrecision]- If enabled, the resulting time
 *                                            will be calculated in seconds and
 *                                            will also countdown every second,
 *                                            until changing; defaults to false
 * @param     {number}       [level]        - The level to calculate the time
 *                                            needed to advance to; defaults to
 *                                            $level + 1
 *
 * @returns   {number}                      - Amount of time
--]]
function timetolevel(extraPrecision, level)
	-- If not extra precision is wanted, just return the regular old value in
	-- minutes
	if not (extraPrecision == true) then
		return _TIMETOLEVEL(extraPrecision or level)
	end

	-- The reason we use this instead of $timems is because you'll almost always
	-- show the time to next level beside the current played time, for which the
	-- majority of HUDs use $charactertime. Also, this is exactly how it's done
	-- in sirmate's MMH, the most used HUD around. So, if we do this, we get to
	-- see both values changing simultaneously and this makes me feel better.
	local curTime = math.floor($charactertime / 1000)

	-- If the experience per hour change, the time to level also changes
	if $exphour ~= _Tracker.lastExpHour then
		_Tracker.timeToLevelChanged = curTime
		_Tracker.lastExpHour = $exphour
	end

	-- If the current experience changes, the experience need to advance to the
	-- level also changes and this, in turn, changes the time to level; One
	-- argue that when the current experience changes, the experience per hour
	-- also does, because effectively you're gaining experience. This, however,
	-- cannot be verified over a non instantaneous period of time and since this
	-- function might be called at long intervals, specially because it is
	-- commonly used in HUDs, we will assume otherwise.
	if $exp ~= _Tracker.lastExp then
		_Tracker.timeToLevelChanged = curTime
		_Tracker.lastExp = $exp
	end

	local timeToLevel = (exptolevel(level) / $exphour) * 3600
	local timeOffset = (curTime - _Tracker.timeToLevelChanged)

	-- Don't really want to return negative values; what would that even mean?
	return math.max(math.round(timeToLevel - timeOffset), 1)
end

--[[
 * If `value` is a function, executes it passing the extra parameters as its
 * parameters, returning the value returned by it; otherwise, simply returns
 * `value`.
 *
 * @since 1.4.0
 *
 * @param     {any}          value          - The variable to be checked
 * @param     {any}          [...]          - Any extra arguments you want to be
 *                                            passed to `value` in case it's a
 *                                            function
 *
 * @returns   {any}                         - The value returned by `value` or
 *                                            `value` itself
--]]
function getvalue(value, ...)
	if type(value) == 'function' then
		return value(...)
	else
		return value
	end
end

--[[
 * Returns the currently opened channel userdata.
 *
 * @since 1.4.0
 *
 * @returns   {userdata}                    - The currently opened channel
--]]
function curchannel()
	foreach channel c do
		if c.iscurrent then
			return c
		end
	end
end

--[[
 * Handles talking to a NPC. Takes care of all waiting times and checks if NPCs
 * channel is open. By default, it uses a waiting method that waits until it
 * sees the the message was actually sent. Optionally, you can opt for the
 * original waitping() solution, passing `normalWait` as true.
 *
 * @since     0.1.0
 * @updated   1.3.1
 *
 * @param     {string...}    messages       - Messages to be said
 * @param     {boolean}      [normalWait]   - If waitping should be used as
 *                                            waiting method; defaults to false
 *
 * @returns   {boolean}                     - A value indicating whether all
 *                                            messages were correctly said
--]]
function npctalk(...)
	local args = {...}

	-- Checks for NPCs around
	-- Blatantly (almost) copied from @Colandus' lib
	local npcFound = false
	foreach creature c 'nfs' do
		if c.dist <= 3 then
			npcFound = true
			break
		end
	end

	if not npcFound then
		return false
	end


	-- Checks for aditional parameters
	local normalWait = false
	if type(table.last(args)) == 'boolean' then
		normalWait = table.remove(args)
	end

	-- Use specified waiting method
	local waitFunction = waitmessage
	if normalWait then
		waitFunction = function()
			waitping()
			return true
		end
	end

	-- We gotta convert all args to strings because there may be some numbers
	-- in between and those wouldn't be correctly said by the bot.
	table.map(args, tostring)

	local msgSuccess = false

	-- Open NPCs channel if needed
	if not ischannel('NPCs') then
		while not msgSuccess do
			say(args[1])
			msgSuccess = waitFunction($name, args[1], 3000, true, MSG_DEFAULT)
		end

		table.remove(args, 1)
		wait(400, 600)
	end

	for k, v in ipairs(args) do
		msgSuccess = false
		while not msgSuccess do

			-- When we have fast hotkeys enabled, the bot sends the messages way
			-- too fast and this ends up causing a huge problem because the
			-- server can't properly read them. So we simulate the time it would
			-- take to actually type the text.
			if $fasthotkeys then
				local minWait, maxWait = get('Settings/TypeWaitTime'):match(REGEX_RANGE)
				minWait, maxWait = tonumber(minWait), tonumber(maxWait)

				-- Even though values can go as low as 10 x 10 ms, there's a
				-- physical cap at about 30 x 30 ms.
				minWait, maxWait = math.max(minWait, 30), math.max(maxWait, 30)

				local waitTime = 0

				for i = 1, #v do
					waitTime = waitTime + math.random(minWait, maxWait)
				end

				-- My measurements indicate at least 15% extra time to actually
				-- press the keys then it should take, even with relatively
				-- high settings. However, the measurements go relatively high
				-- when using extremely short strings. So I made up this weird
				-- formula with the help of Wolfram Alpha.
				waitTime = waitTime * (1 + (3 * (1.15 / #v)^1.15))

				wait(waitTime)
			end

			say('NPCs', v)
			msgSuccess = waitFunction($name, v, 3000, true, MSG_SENT)
			if not msgSuccess then
				if not ischannel('NPCs') then
					return npctalk(select(k, ...))
				end
			end
		end
	end

	return true
end

--[[
 * Handles pressing specific keys in the given sentence. It reads the `keys`
 * argument and presses the keys as if a human was writing it. For special
 * keys, make use of brackets. For instance, to press delete, use [DELETE].
 *
 * @since     0.1.0
 *
 * @param     {string}       keys           - Keys to be pressed
--]]
function press(keys)
	keys = keys:upper()

	for i, j, k in string.gmatch(keys .. '[]', '([^%[]-)%[(.-)%]([^%[]-)') do
		for n = 1, #i do
			keyevent(KEYS[i:at(n)])
		end

		if #j then
			keyevent(KEYS[j])
		end

		for n = 1, #k do
			keyevent(KEYS[k:at(n)])
		end
	end
end





--    _____ __       _                ______     __                  _
--   / ___// /______(_)___  ____ _   / ____/  __/ /____  ____  _____(_)___  ____
--   \__ \/ __/ ___/ / __ \/ __ `/  / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  ___/ / /_/ /  / / / / / /_/ /  / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /____/\__/_/  /_/_/ /_/\__, /  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

--[[
 * Splits the string by the specified delimiter.
 *
 * Returns an array of strings, each of which is a substring of self formed by
 * splitting it on boundaries formed by the string delimiter.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The string to be split
 * @param     {string}       delimiter      - The string delimiter
 *
 * @returns   {array}                       - An array of strings created by
 *                                            splitting the string.
--]]
function string.explode(self, delimiter)
	local result = {}
	self:gsub('[^'.. delimiter ..'*]+', function(s) table.insert(result, (string.gsub(s, '^%s*(.-)%s*$', '%1'))) end)
	return result
end

--[[
 * Returns the nth character in a given string.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The target string
 * @param     {number}       n              - The character's position
 *
 * @returns   {string}                      - The nth character
--]]
function string.at(self, n)
	return self:sub(n, n)
end

--[[
 * Capitalizes the first character in a given string.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The string to be capitalized
 *
 * @returns   {string}                      - The capitalized string
--]]
function string.capitalize(self) -- Working
	return self:at(1):upper() .. self:sub(2):lower()
end

--[[
 * Capitalizes the first character of every word in a given string.
 *
 * @since     0.1.0
 *
 * @param     {string}       self           - The string to be capitalized
 *
 * @returns   {string}                      - The capitalized string
--]]
function string.capitalizeall(self) -- Working
	local t = string.explode(self, ' ')
	table.map(t, string.capitalize)
	return table.concat(t, ' ')
end

--[[
 * Makes sure the given string fits in the given size. If set, adds `trailing`
 * to end of it. If `trueSize` is set to false, the comparison is made using
 * the string length; if it's set to true, the comparison is made using the
 * actual string width, in pixels, gathered by using `measurestring`.
 *
 * @since     0.1.1
 *
 * @param     {string}       self           - The target string
 * @param     {number}       size           - The maximum size
 * @param     {string}       [trailing]     - The trailing string
 * @param     {boolean}      [trueSize]     - Whether the comparison should be
 *                                          - made using real pixel measures.
 *
 * @returns   {string}                      - The final string
--]]
function string.fit(self, size, trailing, trueSize)
	trailing = trailing or '...'

	if size <= 0 then
		return ''
	end

	-- Use the actual pixels measurement if required
	local sizeFunction = string.len
	if trueSize then
		sizeFunction = measurestring
	end

	if sizeFunction(self) <= size then
		return self
	elseif not trueSize then
		return self:sub(0, size - #trailing) .. trailing
	end

	-- Assuming the order of the letters doesn't matter, we'll just append the
	-- trailing text to the beginning, so we don't have to worry about it when
	-- cutting the string for measurements later
	local trailedText = trailing .. self

	-- Helper function
	local function attempt(n)
		return n > 0 and sizeFunction(trailedText:sub(0, n)) <= size
	end

	local ratio = size / sizeFunction(trailedText)
	local suggestedSize = math.round(#trailedText * ratio)
	local firstAttempt = attempt(suggestedSize)

	-- If the first attempt failed, we should start decrementing; if it was
	-- successful, we should start incrementing
	local upDown = tern(firstAttempt, 1, -1)

	-- Keep attempting until we know the result is different; this will mean
	-- that we just reached the turning point, so we can know we have the best
	-- solution for our problem, or the longest string that fits the required
	-- size
	repeat
		suggestedSize = suggestedSize + upDown
	until suggestedSize <= 0 or attempt(suggestedSize) ~= firstAttempt

	if suggestedSize > 0 then
		return self:sub(0, suggestedSize - tern(firstAttempt, 1, 0) - #trailing ) .. trailing
	else
		return ''
	end
end

--[[
 * Checks whether a given string starts with a given substring.
 *
 * @since     1.0.0
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The starting substring
 *
 * @returns   {boolean}                     - Whether it starts or not with the
 *                                            given substring
--]]
function string.starts(self, substr)
	return self:sub(1, #substr) == substr
end

--[[
 * Checks whether a given string ends with a given substring.
 *
 * @since     1.0.0
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The ending substring
 *
 * @returns   {boolean}                     - Whether it ends or not with the
 *                                            given substring
--]]
function string.ends(self, substr)
	return self:sub(-#substr) == substr
end

--[[
 * Forces a given string to begin with a given substring.
 *
 * @since     1.0.0
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The starting substring
 *
 * @returns   {boolean}                     - The string starting with the
 *                                            substring
--]]
function string.begin(self, substr)
	return tern(self:starts(substr), self, substr .. self)
end


--[[
 * Forces a given string to end with a given substring.
 *
 * @since     1.0.0
 *
 * @param     {string}       self           - The target string
 * @param     {string}       substr         - The ending substring
 *
 * @returns   {boolean}                     - The string ending with the
 *                                            substring
--]]
function string.finish(self, substr)
	return tern(self:ends(substr), self, self .. substr)
end

--[[
 * Removes given characters from beginning of given string.
 *
 * @since     1.1.0
 *
 * @param     {string}       self           - The target string
 * @param     {string|table} [chars]        - Characters to trim; defaults to
 *                                            whitespaces
 *
 * @returns   {boolean}                     - The trimmed string
--]]
function string.ltrim(self, chars)
	chars = chars or '%s'
	if type(chars) == 'table' then
		chars = '[' .. table.concat(chars, '') .. ']'
	end

	-- This protects it from matching all characters if '.' is passed
	chars = chars:gsub('%.', '%%.')

	return self:gsub('^' .. chars .. '*(.-)$', '%1')
end

--[[
 * Removes given characters from ending of given string.
 *
 * @since     1.1.0
 *
 * @param     {string}       self           - The target string
 * @param     {string|table} [chars]        - Characters to trim; defaults to
 *                                            whitespaces
 *
 * @returns   {boolean}                     - The trimmed string
--]]
function string.rtrim(self, chars)
	chars = chars or '%s'
	if type(chars) == 'table' then
		chars = '[' .. table.concat(chars, '') .. ']'
	end

	-- This protects it from matching all characters if '.' is passed
	chars = chars:gsub('%.', '%%.')

	return self:gsub('^(.-)' .. chars .. '*$', '%1')
end

--[[
 * Removes given characters from beginning and ending of given string.
 *
 * @since     1.1.0
 *
 * @param     {string}       self           - The target string
 * @param     {string|table} [chars]        - Characters to trim; defaults to
 *                                            whitespaces
 *
 * @returns   {boolean}                     - The trimmed string
--]]
function string.trim(self, chars)
	return self:ltrim(chars):rtrim(chars)
end





--     __  ___      __  __                 __                  _
--    /  |/  /___ _/ /_/ /_     ___  _  __/ /____  ____  _____(_)___  ____
--   / /|_/ / __ `/ __/ __ \   / _ \| |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / /  / / /_/ / /_/ / / /  /  __/>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  /_/\__,_/\__/_/ /_/   \___/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

--[[
 * Rounds to the nearest multiple of mult. If it's exactly between two
 * multiples, rounds up.
 *
 * @since     0.1.0
 * @updated   0.1.1
 *
 * @param     {number}       self           - The number to be rounded
 * @param     {number}       mult           - The multiple base; defaults to 1
 *
 * @returns   {number}                      - The rounded number
--]]
function math.round(self, mult)
	div = div or 1

	if self % div >= 0.5 * div then
		return math.ceil(self, mult)
	else
		return math.floor(self, mult)
	end
end

--[[
 * Rounds up to the nearest multiple of mult.
 *
 * @since     0.1.0
 * @overrides
 *
 * @param     {number}       self           - The number to be rounded
 * @param     {number}       mult           - The multiple base; defaults to 1
 *
 * @returns   {number}                      - The rounded number
--]]
function math.ceil(self, mult)
	mult = mult or 1

	return math._CEIL(self / mult) * mult
end

--[[
 * Rounds down to the nearest multiple of mult.
 *
 * @since     0.1.0
 * @overrides
 *
 * @param     {number}       self           - The number to be rounded
 * @param     {number}       mult           - The multiple base; defaults to 1
 *
 * @returns   {number}                      - The rounded number
--]]
function math.floor(self, mult)
	mult = mult or 1

	return math._FLOOR(self / mult) * mult
end





--   ______      __    __        ______     __                  _
--  /_  __/___ _/ /_  / /__     / ____/  __/ /____  ____  _____(_)___  ____
--   / / / __ `/ __ \/ / _ \   / __/ | |/_/ __/ _ \/ __ \/ ___/ / __ \/ __ \
--  / / / /_/ / /_/ / /  __/  / /____>  </ /_/  __/ / / (__  ) / /_/ / / / /
-- /_/  \__,_/_.___/_/\___/  /_____/_/|_|\__/\___/_/ /_/____/_/\____/_/ /_/
--

--[[
 * Checks wheter given table is empty, that is, has no elements. This may be
 * needed for tables with non-numeric indexes, where the length operator (#)
 * might not work properly.
 *
 * NOTE: May return incorrect values if the given table contains nil values.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {boolean}                     - Whether the target table is empty
--]]
function table.isempty(self)
	if #self ~= 0 or next(self) ~= nil then
		return false
	else
		for k, v in pairs(self) do
			return false
		end
	end
	return true
end

--[[
 * Returns the amount of elements present in the table. This may be needed for
 * tables with non-numeric indexes, where the length operator (#) might not
 * work properly.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The number of elements inside the
 *                                            target table
--]]
function table.size(self)
	local i = 0

	for v in pairs(self) do
		i = i + 1
	end

	return i
end

--[[
 * Runs a routine through every item in the given table. The routine to be ran
 * will receive as arguments, for each item, it's value and correspondet index.
 *
 * @since     0.1.0
 * @updated   1.4.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran on each element
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be iterated; defaults to false
 *
 * @returns   {table}                       - A table with the returning values
 *                                            for each item
--]]
function table.each(self, f, recursive)
	local r = {}

	for k, v in pairs(self) do
		if recursive and type(v) == 'table' then
			r[k] = table.each(v, f, recursive)
		else
			r[k] = f(v, k)
		end
	end

	return r
end

--[[
 * Runs a routine through every item in the given table and replace the item
 * with the value returned by it. The routine to be ran will receive as
 * arguments, for each item, it's value and correspondet index.
 *
 * @since     0.1.0
 * @updated   1.4.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran on each element
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be iterated; defaults to false
--]]
function table.map(self, f, recursive)
	for k, v in pairs(self) do
		if recursive and type(v) == 'table' then
			table.map(v, f, true)
		else
			self[k] = f(v, k)
		end
	end
end

--[[
 * Returns the first item of the given table.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {any}                         - The first item of the given table
--]]
function table.first(self)
	return self[1]
end

--[[
 * Returns the last item of the given table.
 *
 * @since     0.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {any}                         - The last item of the given table
--]]
function table.last(self)
	return self[#self]
end

--[[
 * Makes a deep, by value, copy of a table. This solves referencing problems.
 * This may be slow for big, complex tables; use carefully.
 *
 * Adapted from http://lua-users.org/wiki/CopyTable
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {table}                       - The copy of the table
--]]
function table.copy(self)
    local origType, copy = type(self)

    if origType == 'table' then
        copy = {}

        for origKey, origValue in next, self, nil do
            copy[table.copy(origKey)] = table.copy(origValue)
        end

        setmetatable(copy, table.copy(getmetatable(self)))
    else
        copy = self
    end
    return copy
end

--[[
 * Normalizes the given table, removing nil values and rearranging the indexes.
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
--]]
function table.normalize(self)
	for i = #self, 1, -1 do
		if self[i] == nil then
			table.remove(self, i)
		end
	end
end

--[[
 * Runs a routine through every item in the given table and remove it from the
 * table if the routine returns false.
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
 * @param     {function}     f              - Routine to be ran as filter;
 *                                            default removes falsy values
--]]
function table.filter(self, f)
	if not f then
		f = tobool
		table.normalize(self)
	end

	for k, v in pairs(self) do
		if not f(v, k) then
			table.remove(self, k)
		end
	end
end

--[[
 * Merges the items of the given tables to a single table.
 *
 * @since     1.1.0
 * @updated   1.4.0
 *
 * @param     {table}        [table1], ...  - Tables to be merged
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be merged; defaults to false
 *
 * @returns  {table}                        - A table with all items on the
 *                                            given tables
--]]
function table.merge(...)
	local args = {...}
	local r = {}
	local recursive, f

	if (type(table.last(args)) == 'boolean') then
		recursive = table.remove(args)
	end

	if #args[1] ~= table.size(args[1]) then
		function f(v, k)
			if recursive and type(r[k]) == 'table' and type(v) == 'table' then
				r[k] = table.merge(r[k], v, true)
			else
				r[k] = v
			end
		end
	else
		function f(v)
			local rv = v
			table.insert(r, rv)
		end
	end

	table.each(args, function(v)
		table.each(v, f, recursive)
	end)

	return r
end

--[[
 * Returns the sum of all items in the given table.
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The sum of all items
--]]
function table.sum(self)
	local s = 0
	table.each(self, function(v) s = s + v end)
	return s
end

--[[
 * Returns the average of all items in the given table.
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The average of all items
--]]
function table.average(self)
	return table.sum(self) / #self
end

--[[
 * Returns the maximum value of all items in the given table.
 *
 * @since     1.1.0
 *
 * @param	{table}		self	- The target table
 *
 * @returns {number}			- The maximum value of all items
--]]
function table.max(self)
	return math.max(table.unpack(self))
end

--[[
 * Returns the minimum value of all items in the given table.
 *
 * @since     1.1.0
 *
 * @param     {table}        self           - The target table
 *
 * @returns   {number}                      - The minimum value of all items
--]]
function table.min(self)
	return math.min(table.unpack(self))
end

--[[
 * Flattens the table, removing any other tables inside `self` and inserting the
 * values inside those tables.
 *
 * @since     1.4.0
 *
 * @param     {table}        self           - The target table
 * @param     {boolean}      [recursive]    - Whether inner tables should also
 *                                            be flattened; defaults to false
--]]
function table.flatten(self, recursive)
	-- I would have liked to use ipairs() here, but since we'll need to skip
	-- added indexes, I couldn't =/
	for i = 1, #self do
		if type(self[i]) == 'table' then
			if recursive then
				table.flatten(self[i])
			end

			for j, v in ipairs(self[i]) do
				table.insert(self, i + j, v)
			end

			tableIndex = i
			i = i + #self[i] - 1
			table.remove(self, tableIndex)
		end
	end
end




--     _______ __        __  __                _____
--    / ____(_) /__     / / / /___ _____  ____/ / (_)___  ____ _
--   / /_  / / / _ \   / /_/ / __ `/ __ \/ __  / / / __ \/ __ `/
--  / __/ / / /  __/  / __  / /_/ / / / / /_/ / / / / / / /_/ /
-- /_/   /_/_/\___/  /_/ /_/\__,_/_/ /_/\__,_/_/_/_/ /_/\__, /
--                                                     /____/

file = {}

--[[
 * Checks wheter given file exists in disk or not.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 *
 * @returns   {boolean}                     - Whether it exists or not
--]]
function file.exists(filename)
	local handler = io.open(filename)

	if type(handler) ~= 'nil' then
		handler:close()
		return true
	end
	return false
end

--[[
 * Gets all the content of a given file. Returns nil if file doesn't exist.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be read
 *
 * @returns   {string}                      - File content
--]]
function file.content(filename)
	if not file.exists(filename) then
		return nil
	end

	local handler = io.open(filename, 'r')
	local content = handler:read('*all')
	handler:close()
	return content
end

--[[
 * Gets the number of lines in a given file. Returns -1 if file doesn't exist.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 *
 * @returns   {number}                      - File lines count
--]]
function file.linescount(filename)
	if not file.exists(filename) then
		return -1
	end

	local l = 0
	for line in io.lines(filename) do
		l = l + 1
	end

	return l
end

--[[
 * Gets the content of the nth file line. Returns nil if file doesn't exist.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be read
 * @param     {number}       linenum        - Line number
 *
 * @returns   {string}                      - Line content
--]]
function file.line(filename, linenum)
	if not file.exists(filename) then
			return nil
	end

	local l, linev = 0, ''
	for line in io.lines(filename) do
		l = l + 1
		if l == linenum then
			linev = line
			break
		end
	end

	return linev
end

--[[
 * Appends content to the end of given file. If the file does not exist, it's
 * created.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be written on
 * @param     {string}       content        - Content to be appended
--]]
function file.write(filename, content)
	local handler = io.open(filename, 'a+')
	handler:write(content)
	handler:close()
end

--[[
 * Write content to the given file, erasing any previous content. If the file
 * does not exist, it's created.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be written on
 * @param     {string}       content        - Content to be written
--]]
function file.rewrite(filename, content)
	local handler = io.open(filename, 'w+')
	handler:write(content)
	handler:close()
end

--[[
 * Clears all the content of the given file. If the file does not exist, it's
 * created. Useful to create new, empty files.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be cleared
--]]
function file.clear(filename)
	local handler = io.open(filename, 'w+')
	handler:close()
end

--[[
 * Appends content to the end of given file, on a new line. If the file does
 * not exist, it's created.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be written on
 * @param     {string}       content        - Content to be appended
--]]
function file.writeline(filename, content)
	local s = ''
	if file.linescount(filename) > 0 then
		s = '\n'
	end

	file.write(filename, s .. content)
end

--[[
 * Checks whether the any file line matches given content. Returns false if it
 * can't be found.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 * @param     {string}       content        - Content to be matched against
 *
 * @returns   {number}                      - Matching line number
--]]
function file.isline(filename, content)
	if not file.exists(filename) then
		return false
	end

	local l = 0
	for line in io.lines(filename) do
		l = l + 1
		if line == content then
			return l
		end
	end

	return false
end

--[[
 * Executes the content of given file. Returns nil if file doesn't exist.
 *
 * @since     0.1.0
 *
 * @param     {string}       filename       - File name to be checked
 *
 * @returns   {any}                         - Anything returned by the code ran
--]]
function file.exec(filename)
	if not file.exists(filename) then
		return nil
	end

	return exec(file.content(filename))
end





--   ______                                                    _______
--  /_  __/__  ____ ___  ____  ____  _________ ________  __   / ____(_)  _____  _____
--   / / / _ \/ __ `__ \/ __ \/ __ \/ ___/ __ `/ ___/ / / /  / /_  / / |/_/ _ \/ ___/
--  / / /  __/ / / / / / /_/ / /_/ / /  / /_/ / /  / /_/ /  / __/ / />  </  __(__  )
-- /_/  \___/_/ /_/ /_/ .___/\____/_/   \__,_/_/   \__, /  /_/   /_/_/|_|\___/____/
--                   /_/                          /____/

-- Temporary fix for Lucas' table.stringformat
-- Now handles userdatas and booleans correctly
function table.stringformat(self, tablename, separator)
	if type(self) ~= 'table' then
		return ''
	end
	separator = separator or ''
	tablename = tablename or ''
	local ret
	if tablename == '' then
		ret = '{'
	else
		ret = tablename..' = {'
	end
	local count = 0
	for i,j in ipairs(self) do
		count = count+1
		local valType = type(j)
		if valType == 'string' then
			ret = ret..'"'..j..'", '..separator
		elseif valType == 'number' then
			ret = ret..j..', '..separator
		elseif valType == 'boolean' then
			ret = ret..tostring(j)..', '..separator
		elseif valType == 'nil' then
			ret = ret..'nil, '..separator
		elseif valType == 'table' then
			ret = ret..table.stringformat(j)..', '..separator
		elseif valType == 'userdata' then
			ret = ret..userdatastringformat(j)..', '..separator
		end
	end
	if count == 0 then
		for i,j in pairs(self) do
			local valType = type(j)
			if valType == 'string' then
				ret = ret..i..' = "'..j..'", '..separator
			elseif valType == 'number' then
				ret = ret..i..' = '..j..', '..separator
			elseif valType == 'boolean' then
				ret = ret..i..' = '..tostring(j)..', '..separator
			elseif valType == 'nil' then
				ret = ret..i..' = nil, '..separator
			elseif valType == 'table' then
				ret = ret..i..' = '..table.stringformat(j)..', '..separator
			elseif valType == 'userdata' then
				ret = ret..i..' = '..userdatastringformat(j)..', '..separator
			end
		end
	end
	return ret:sub(1,#ret-2)..'}'
end





--     ___    ___
--    /   |  / (_)___ _________  _____
--   / /| | / / / __ `/ ___/ _ \/ ___/
--  / ___ |/ / / /_/ (__  )  __(__  )
-- /_/  |_/_/_/\__,_/____/\___/____/
--

set = setsetting
get = getsetting





--    ______           __                     ________
--   / ____/_  _______/ /_____  ____ ___     / ____/ /___ ______________  _____
--  / /   / / / / ___/ __/ __ \/ __ `__ \   / /   / / __ `/ ___/ ___/ _ \/ ___/
-- / /___/ /_/ (__  ) /_/ /_/ / / / / / /  / /___/ / /_/ (__  |__  )  __(__  )
-- \____/\__,_/____/\__/\____/_/ /_/ /_/   \____/_/\__,_/____/____/\___/____/
--

Point = { __class = 'Point' }
PointMT = { __index = Point }

function Point:new(x, y)
	if type(x) == 'Point' then
		return x
	elseif type(x) == 'table' or type(x) == 'userdata' then
		if x.x ~= nil then
			x, y = x.x, x.y
		else
			x, y = x[1], x[2]
		end
	end

	if type(x) ~= 'number' or type(y) ~= 'number' then
		return nil
	end

	x, y = math.round(x), math.round(y)

	local newObj = {x = x, y = y}
	setmetatable(newObj, PointMT)
	return newObj
end

function PointMT:__add(value)
	self = Point:new(self)
	value = Point:new(value)

	return Point:new(self.x + value.x, self.y + value.y)
end

function PointMT:__sub(value)
	self = Point:new(self)
	value = Point:new(value)

	return Point:new(self.x - value.x, self.y - value.y)
end

function PointMT:__mul(value)
	self = Point:new(self)
	value = Point:new(value)

	return Point:new(self.x * value.x, self.y * value.y)
end

function PointMT:__div(value)
	self = Point:new(self)
	value = Point:new(value)

	return Point:new(self.x / value.x, self.y / value.y)
end

function PointMT:__unm()
	return self * {-1, -1}
end

function PointMT:__eq(value)
	return self.x == value.x and self.y == value.y
end

function PointMT:__tostring()
	return '{x = ' .. self.x .. ', y = ' .. self.y .. '}'
end


Area = { __class = 'Area' }
AreaMT = { __index = Area }

function Area:new(firstCorner, width, height)
	-- Special handling for rect
	if type(firstCorner) == 'userdata' and firstCorner.objtype == 'rect' then
		return Area:new(Point:new(firstCorner.left, firstCorner.top), firstCorner.width, firstCorner.height)
	end

	firstCorner = Point:new(firstCorner)

	local secondCorner = Point:new(width)
	if secondCorner == nil then
		secondCorner = firstCorner + Point:new(width, height)
	end

	if type(firstCorner) ~= 'Point' or type(secondCorner) ~= 'Point' then
		return nil
	end

	local newObj = {
		topLeft = Point:new(math.min(firstCorner.x, secondCorner.x), math.min(firstCorner.y, secondCorner.y)),
		botRight = Point:new(math.max(firstCorner.x, secondCorner.x), math.max(firstCorner.y, secondCorner.y))
	}
	setmetatable(newObj, AreaMT)
	return newObj
end

function Area:createFromWaypoint(waypoint)
	local topLeft = Point:new(get(waypoint, 'Coordinates'):match(REGEX_COORDS))
	local width, height = get(waypoint, 'Range'):match(REGEX_RANGE)

	return Area:new(topLeft, width, height)
end

function Area:createFromSpecialArea(specialArea)
	local topLeft = Point:new(get(specialArea, 'Coordinates'):match(REGEX_COORDS))
	local width, height = get(specialArea, 'Size'):match(REGEX_RANGE)

	return Area:new(topLeft, width, height)
end

function Area:createFromAreaTable(areaTable)
	return Area:new(Point:new(areaTable.left, areaTable.top), areaTable.width, areaTable.height)
end

function Area:extend(top, right, bottom, left)
	-- This gives us a CSS-like workflow; the one that usually works in margin
	-- and padding shorthands
	top    = top    or 0
	right  = right  or top
	bottom = bottom or top
	left   = left   or right

	self.topLeft = self.topLeft - Point:new(top, left)
	self.botRight = self.botRight + Point:new(bottom, right)
end

function Area:getLeft()
	return self.topLeft.x
end

function Area:getTop()
	return self.topLeft.y
end

function Area:getRight()
	return self.botRight.x
end

function Area:getBottom()
	return self.botRight.y
end

function Area:getWidth()
	return self.botRight.x - self.topLeft.x
end

function Area:getHeight()
	return self.botRight.y - self.topLeft.y
end

function Area:hasPoint(point, y)
	point = Point:new(point, y)

	return point.x >= self.topLeft.x  and
	       point.y >= self.topLeft.y  and
	       point.x <= self.botRight.x and
	       point.y <= self.botRight.y
end

function Area:move(point, y)
	point = Point:new(point, y)

	self.topLeft = self.topLeft + point
	self.botRight = self.botRight + point
end

function AreaMT:__tostring()
	return '{topLeft = ' .. tostring(self.topLeft) .. ', botRight = ' .. tostring(self.botRight) .. '}'
end


HUD = { __class = 'HUD' }
HUDMT = { __index = HUD }

function HUD:new(options)
	newObj = {
		uniqueId      = nil,
		draggable     = false,
		dragEvent     = IEVENT_MMOUSEDOWN,
		dragStopEvent = IEVENT_MMOUSEUP,
		dragTarget    = nil,
		savePosition  = false,
		startPosition = Point:new(0, 0),
		posRelativeTo = function() return Point:new(0, 0) end,
		database      = $botdb,

		dragging      = false
	}

	newObj = table.merge(newObj, options, true)

	if newObj.savePosition then
		if newObj.uniqueId == nil then
			error('The uniqueId attribute is required when savePosition is enabled.')
		end

		local oldPos = newObj.database:getvalue('HUDs Info', newObj.uniqueId .. '.position')
		if oldPos ~= nil then
			newObj.startPosition = newObj.posRelativeTo() + Point:new(oldPos:explode(';'))
		end
	end

	setmetatable(newObj, HUDMT)
	return newObj
end

function HUD:bootstrap()
	filterinput(false, self.draggable, false, false)
	self:setPosition(self.startPosition)
end

function HUD:setPosition(x, y)
	local p = Point:new(x, y)
	setposition(p.x, p.y)

	if self.savePosition then
		self:updateSavedPosition()
	end
end

function HUD:handleInput(e)
	if self.draggable and (self.dragTarget == nil or self.dragTarget == e.elementid) then
		if e.type == self.dragEvent then
			self:startDragging()
		elseif e.type == self.dragStopEvent then
			self:stopDragging()
		end
	end
end

function HUD:run()
	if self.draggable then
		self:drag()
	end
end

function HUD:startDragging()
	self.dragging = true
	self.mousePos = Point:new($cursor)
end

function HUD:stopDragging()
	self.dragging = false

	-- Had to move it to HUD:setPosition(), because apparently getposition()
	-- doesn't work inside inputevents()
	--[[ if self.savePosition then
		self:updateSavedPosition()
	end ]]--
end

function HUD:updateSavedPosition()
	local relativePos = Point:new(getposition()) - self.posRelativeTo()
	self.database:setvalue('HUDs Info', self.uniqueId .. '.position', relativePos.x .. ';' .. relativePos.y)
end

function HUD:drag()
	if self.dragging then
		auto(10)

		local curMouse = Point:new($cursor)

		self:setPosition((curMouse - self.mousePos) + getposition())
		self.mousePos = curMouse
	end
end





--        _______ ____  _   __   ____
--       / / ___// __ \/ | / /  / __ \____ ______________  _____
--  __  / /\__ \/ / / /  |/ /  / /_/ / __ `/ ___/ ___/ _ \/ ___/
-- / /_/ /___/ / /_/ / /|  /  / ____/ /_/ / /  (__  )  __/ /
-- \____//____/\____/_/ |_/  /_/    \__,_/_/  /____/\___/_/
--

--[==[

* This is a modified version of the original code *

David Kolf's JSON module for Lua 5.1/5.2
========================================
Contact
-------

You can contact the author by sending an e-mail to 'david' at the
domain 'dkolf.de'.

---------------------------------------------------------------------

*Copyright (C) 2010-2013 David Heiko Kolf*

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]==]--

JSON = (function()

	-- global dependencies:
	local pairs, type, tostring, tonumber, getmetatable, setmetatable, rawset =
				pairs, type, tostring, tonumber, getmetatable, setmetatable, rawset
	local error, require, pcall, select = error, require, pcall, select
	local floor, huge = math.floor, math.huge
	local strrep, gsub, strsub, strbyte, strchar, strfind, strlen, strformat =
				string.rep, string.gsub, string.sub, string.byte, string.char,
				string.find, string.len, string.format
	local strmatch = string.match
	local concat = table.concat

	local json = { version = "dkjson 2.4" }

	local _ENV = nil -- blocking globals in Lua 5.2

	json.null = setmetatable ({}, {
		__tojson = function () return "null" end
	})

	local function isarray (tbl)
		local max, n, arraylen = 0, 0, 0
		for k,v in pairs (tbl) do
			if k == 'n' and type(v) == 'number' then
				arraylen = v
				if v > max then
					max = v
				end
			else
				if type(k) ~= 'number' or k < 1 or floor(k) ~= k then
					return false
				end
				if k > max then
					max = k
				end
				n = n + 1
			end
		end
		if max > 10 and max > arraylen and max > n * 2 then
			return false -- don't create an array with too many holes
		end
		return true, max
	end

	local escapecodes = {
		["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f",
		["\n"] = "\\n",  ["\r"] = "\\r",  ["\t"] = "\\t"
	}

	local function escapeutf8 (uchar)
		local value = escapecodes[uchar]
		if value then
			return value
		end
		local a, b, c, d = strbyte (uchar, 1, 4)
		a, b, c, d = a or 0, b or 0, c or 0, d or 0
		if a <= 0x7f then
			value = a
		elseif 0xc0 <= a and a <= 0xdf and b >= 0x80 then
			value = (a - 0xc0) * 0x40 + b - 0x80
		elseif 0xe0 <= a and a <= 0xef and b >= 0x80 and c >= 0x80 then
			value = ((a - 0xe0) * 0x40 + b - 0x80) * 0x40 + c - 0x80
		elseif 0xf0 <= a and a <= 0xf7 and b >= 0x80 and c >= 0x80 and d >= 0x80 then
			value = (((a - 0xf0) * 0x40 + b - 0x80) * 0x40 + c - 0x80) * 0x40 + d - 0x80
		else
			return ""
		end
		if value <= 0xffff then
			return strformat ("\\u%.4x", value)
		elseif value <= 0x10ffff then
			-- encode as UTF-16 surrogate pair
			value = value - 0x10000
			local highsur, lowsur = 0xD800 + floor (value/0x400), 0xDC00 + (value % 0x400)
			return strformat ("\\u%.4x\\u%.4x", highsur, lowsur)
		else
			return ""
		end
	end

	local function fsub (str, pattern, repl)
		-- gsub always builds a new string in a buffer, even when no match
		-- exists. First using find should be more efficient when most strings
		-- don't contain the pattern.
		if strfind (str, pattern) then
			return gsub (str, pattern, repl)
		else
			return str
		end
	end

	local function quotestring (value)
		-- based on the regexp "escapable" in https://github.com/douglascrockford/JSON-js
		value = fsub (value, "[%z\1-\31\"\\\127]", escapeutf8)
		if strfind (value, "[\194\216\220\225\226\239]") then
			value = fsub (value, "\194[\128-\159\173]", escapeutf8)
			value = fsub (value, "\216[\128-\132]", escapeutf8)
			value = fsub (value, "\220\143", escapeutf8)
			value = fsub (value, "\225\158[\180\181]", escapeutf8)
			value = fsub (value, "\226\128[\140-\143\168-\175]", escapeutf8)
			value = fsub (value, "\226\129[\160-\175]", escapeutf8)
			value = fsub (value, "\239\187\191", escapeutf8)
			value = fsub (value, "\239\191[\176-\191]", escapeutf8)
		end
		return "\"" .. value .. "\""
	end
	json.quotestring = quotestring

	local function replace(str, o, n)
		local i, j = strfind (str, o, 1, true)
		if i then
			return strsub(str, 1, i-1) .. n .. strsub(str, j+1, -1)
		else
			return str
		end
	end

	-- locale independent num2str and str2num functions
	local decpoint, numfilter

	local function updatedecpoint ()
		decpoint = strmatch(tostring(0.5), "([^05+])")
		-- build a filter that can be used to remove group separators
		numfilter = "[^0-9%-%+eE" .. gsub(decpoint, "[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0") .. "]+"
	end

	updatedecpoint()

	local function num2str (num)
		return replace(fsub(tostring(num), numfilter, ""), decpoint, ".")
	end

	local function str2num (str)
		local num = tonumber(replace(str, ".", decpoint))
		if not num then
			updatedecpoint()
			num = tonumber(replace(str, ".", decpoint))
		end
		return num
	end

	local function addnewline2 (level, buffer, buflen)
		buffer[buflen+1] = "\n"
		buffer[buflen+2] = strrep ("  ", level)
		buflen = buflen + 2
		return buflen
	end

	function json.addnewline (state)
		if state.indent then
			state.bufferlen = addnewline2 (state.level or 0,
														 state.buffer, state.bufferlen or #(state.buffer))
		end
	end

	local encode2 -- forward declaration

	local function addpair (key, value, prev, indent, level, buffer, buflen, tables, globalorder)
		local kt = type (key)
		if kt ~= 'string' and kt ~= 'number' then
			return nil, "type '" .. kt .. "' is not supported as a key by JSON."
		end
		if prev then
			buflen = buflen + 1
			buffer[buflen] = ","
		end
		if indent then
			buflen = addnewline2 (level, buffer, buflen)
		end
		buffer[buflen+1] = quotestring (key)
		buffer[buflen+2] = ":"
		return encode2 (value, indent, level, buffer, buflen + 2, tables, globalorder)
	end

	encode2 = function (value, indent, level, buffer, buflen, tables, globalorder)
		local valtype = type (value)
		local valmeta = getmetatable (value)
		valmeta = type (valmeta) == 'table' and valmeta -- only tables
		local valtojson = valmeta and valmeta.__tojson
		if valtojson then
			if tables[value] then
				return nil, "reference cycle"
			end
			tables[value] = true
			local state = {
					indent = indent, level = level, buffer = buffer,
					bufferlen = buflen, tables = tables, keyorder = globalorder
			}
			local ret, msg = valtojson (value, state)
			if not ret then return nil, msg end
			tables[value] = nil
			buflen = state.bufferlen
			if type (ret) == 'string' then
				buflen = buflen + 1
				buffer[buflen] = ret
			end
		elseif value == nil then
			buflen = buflen + 1
			buffer[buflen] = "null"
		elseif valtype == 'number' then
			local s
			if value ~= value or value >= huge or -value >= huge then
				-- This is the behaviour of the original JSON implementation.
				s = "null"
			else
				s = num2str (value)
			end
			buflen = buflen + 1
			buffer[buflen] = s
		elseif valtype == 'boolean' then
			buflen = buflen + 1
			buffer[buflen] = value and "true" or "false"
		elseif valtype == 'string' then
			buflen = buflen + 1
			buffer[buflen] = quotestring (value)
		elseif valtype == 'table' then
			if tables[value] then
				return nil, "reference cycle"
			end
			tables[value] = true
			level = level + 1
			local isa, n = isarray (value)
			if n == 0 and valmeta and valmeta.__jsontype == 'object' then
				isa = false
			end
			local msg
			if isa then -- JSON array
				buflen = buflen + 1
				buffer[buflen] = "["
				for i = 1, n do
					buflen, msg = encode2 (value[i], indent, level, buffer, buflen, tables, globalorder)
					if not buflen then return nil, msg end
					if i < n then
						buflen = buflen + 1
						buffer[buflen] = ","
					end
				end
				buflen = buflen + 1
				buffer[buflen] = "]"
			else -- JSON object
				local prev = false
				buflen = buflen + 1
				buffer[buflen] = "{"
				local order = valmeta and valmeta.__jsonorder or globalorder
				if order then
					local used = {}
					n = #order
					for i = 1, n do
						local k = order[i]
						local v = value[k]
						if v then
							used[k] = true
							buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder)
							prev = true -- add a seperator before the next element
						end
					end
					for k,v in pairs (value) do
						if not used[k] then
							buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder)
							if not buflen then return nil, msg end
							prev = true -- add a seperator before the next element
						end
					end
				else -- unordered
					for k,v in pairs (value) do
						buflen, msg = addpair (k, v, prev, indent, level, buffer, buflen, tables, globalorder)
						if not buflen then return nil, msg end
						prev = true -- add a seperator before the next element
					end
				end
				if indent then
					buflen = addnewline2 (level - 1, buffer, buflen)
				end
				buflen = buflen + 1
				buffer[buflen] = "}"
			end
			tables[value] = nil
		else
			return nil, "type '" .. valtype .. "' is not supported by JSON."
		end
		return buflen
	end

	function json.encode (value, state)
		state = state or {}
		local oldbuffer = state.buffer
		local buffer = oldbuffer or {}
		updatedecpoint()
		local ret, msg = encode2 (value, state.indent, state.level or 0,
										 buffer, state.bufferlen or 0, state.tables or {}, state.keyorder)
		if not ret then
			error (msg, 2)
		elseif oldbuffer then
			state.bufferlen = ret
			return true
		else
			return concat (buffer)
		end
	end

	local function loc (str, where)
		local line, pos, linepos = 1, 1, 0
		while true do
			pos = strfind (str, "\n", pos, true)
			if pos and pos < where then
				line = line + 1
				linepos = pos
				pos = pos + 1
			else
				break
			end
		end
		return "line " .. line .. ", column " .. (where - linepos)
	end

	local function unterminated (str, what, where)
		return nil, strlen (str) + 1, "unterminated " .. what .. " at " .. loc (str, where)
	end

	local function scanwhite (str, pos)
		while true do
			pos = strfind (str, "%S", pos)
			if not pos then return nil end
			if strsub (str, pos, pos + 2) == "\239\187\191" then
				-- UTF-8 Byte Order Mark
				pos = pos + 3
			else
				return pos
			end
		end
	end

	local escapechars = {
		["\""] = "\"", ["\\"] = "\\", ["/"] = "/", ["b"] = "\b", ["f"] = "\f",
		["n"] = "\n", ["r"] = "\r", ["t"] = "\t"
	}

	local function unichar (value)
		if value < 0 then
			return nil
		elseif value <= 0x007f then
			return strchar (value)
		elseif value <= 0x07ff then
			return strchar (0xc0 + floor(value/0x40),
											0x80 + (floor(value) % 0x40))
		elseif value <= 0xffff then
			return strchar (0xe0 + floor(value/0x1000),
											0x80 + (floor(value/0x40) % 0x40),
											0x80 + (floor(value) % 0x40))
		elseif value <= 0x10ffff then
			return strchar (0xf0 + floor(value/0x40000),
											0x80 + (floor(value/0x1000) % 0x40),
											0x80 + (floor(value/0x40) % 0x40),
											0x80 + (floor(value) % 0x40))
		else
			return nil
		end
	end

	local function scanstring (str, pos)
		local lastpos = pos + 1
		local buffer, n = {}, 0
		while true do
			local nextpos = strfind (str, "[\"\\]", lastpos)
			if not nextpos then
				return unterminated (str, "string", pos)
			end
			if nextpos > lastpos then
				n = n + 1
				buffer[n] = strsub (str, lastpos, nextpos - 1)
			end
			if strsub (str, nextpos, nextpos) == "\"" then
				lastpos = nextpos + 1
				break
			else
				local escchar = strsub (str, nextpos + 1, nextpos + 1)
				local value
				if escchar == "u" then
					value = tonumber (strsub (str, nextpos + 2, nextpos + 5), 16)
					if value then
						local value2
						if 0xD800 <= value and value <= 0xDBff then
							-- we have the high surrogate of UTF-16. Check if there is a
							-- low surrogate escaped nearby to combine them.
							if strsub (str, nextpos + 6, nextpos + 7) == "\\u" then
								value2 = tonumber (strsub (str, nextpos + 8, nextpos + 11), 16)
								if value2 and 0xDC00 <= value2 and value2 <= 0xDFFF then
									value = (value - 0xD800)  * 0x400 + (value2 - 0xDC00) + 0x10000
								else
									value2 = nil -- in case it was out of range for a low surrogate
								end
							end
						end
						value = value and unichar (value)
						if value then
							if value2 then
								lastpos = nextpos + 12
							else
								lastpos = nextpos + 6
							end
						end
					end
				end
				if not value then
					value = escapechars[escchar] or escchar
					lastpos = nextpos + 2
				end
				n = n + 1
				buffer[n] = value
			end
		end
		if n == 1 then
			return buffer[1], lastpos
		elseif n > 1 then
			return concat (buffer), lastpos
		else
			return "", lastpos
		end
	end

	local scanvalue -- forward declaration

	local function scantable (what, closechar, str, startpos, nullval, objectmeta, arraymeta)
		local len = strlen (str)
		local tbl, n = {}, 0
		local pos = startpos + 1
		if what == 'object' then
			setmetatable (tbl, objectmeta)
		else
			setmetatable (tbl, arraymeta)
		end
		while true do
			pos = scanwhite (str, pos)
			if not pos then return unterminated (str, what, startpos) end
			local char = strsub (str, pos, pos)
			if char == closechar then
				return tbl, pos + 1
			end
			local val1, err
			val1, pos, err = scanvalue (str, pos, nullval, objectmeta, arraymeta)
			if err then return nil, pos, err end
			pos = scanwhite (str, pos)
			if not pos then return unterminated (str, what, startpos) end
			char = strsub (str, pos, pos)
			if char == ":" then
				if val1 == nil then
					return nil, pos, "cannot use nil as table index (at " .. loc (str, pos) .. ")"
				end
				pos = scanwhite (str, pos + 1)
				if not pos then return unterminated (str, what, startpos) end
				local val2
				val2, pos, err = scanvalue (str, pos, nullval, objectmeta, arraymeta)
				if err then return nil, pos, err end
				tbl[val1] = val2
				pos = scanwhite (str, pos)
				if not pos then return unterminated (str, what, startpos) end
				char = strsub (str, pos, pos)
			else
				n = n + 1
				tbl[n] = val1
			end
			if char == "," then
				pos = pos + 1
			end
		end
	end

	scanvalue = function (str, pos, nullval, objectmeta, arraymeta)
		pos = pos or 1
		pos = scanwhite (str, pos)
		if not pos then
			return nil, strlen (str) + 1, "no valid JSON value (reached the end)"
		end
		local char = strsub (str, pos, pos)
		if char == "{" then
			return scantable ('object', "}", str, pos, nullval, objectmeta, arraymeta)
		elseif char == "[" then
			return scantable ('array', "]", str, pos, nullval, objectmeta, arraymeta)
		elseif char == "\"" then
			return scanstring (str, pos)
		else
			local pstart, pend = strfind (str, "^%-?[%d%.]+[eE]?[%+%-]?%d*", pos)
			if pstart then
				local number = str2num (strsub (str, pstart, pend))
				if number then
					return number, pend + 1
				end
			end
			pstart, pend = strfind (str, "^%a%w*", pos)
			if pstart then
				local name = strsub (str, pstart, pend)
				if name == "true" then
					return true, pend + 1
				elseif name == "false" then
					return false, pend + 1
				elseif name == "null" then
					return nullval, pend + 1
				end
			end
			return nil, pos, "no valid JSON value at " .. loc (str, pos)
		end
	end

	local function optionalmetatables(...)
		if select("#", ...) > 0 then
			return ...
		else
			return {__jsontype = 'object'}, {__jsontype = 'array'}
		end
	end

	function json.decode (str, pos, nullval, ...)
		local objectmeta, arraymeta = optionalmetatables(...)
		return scanvalue (str, pos, nullval, objectmeta, arraymeta)
	end

	return json
end)()

print("Raphael's Library Version: " .. RAPHAEL_LIB)
