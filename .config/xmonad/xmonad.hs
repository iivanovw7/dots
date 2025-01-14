  -- Base
import XMonad
import XMonad.Hooks.FadeInactive
import System.Directory
import System.IO (hClose, hPutStr, hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1, copyToAll, killAllOtherCopies)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import Data.Word
import Data.Ratio ((%)) -- for video
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat, doRectFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack, trayerAboveXmobarEventHook, trayAbovePanelEventHook, trayerPaddingXmobarEventHook, trayPaddingXmobarEventHook, trayPaddingEventHook)
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor

import Colors.MonokaiPro
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras

myFont :: String
myFont = "xft:Jetbrains Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask

myTerminal :: String
myTerminal = "ghostty"

myBrowser :: String
myBrowser = "firefox"

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "

myEditor :: String
myEditor = "emacsclient -c -a 'emacs' "

myBorderWidth :: Dimension
myBorderWidth = 3

myNormColor :: String
myNormColor   = colorBack

myFocusColor :: String
myFocusColor  = color13

mySoundPlayer :: String
mySoundPlayer = "ffplay -nodisp -autoexit "

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
  spawn "killall conky"
  spawn "killall xmobar"
  spawn "killall trayer"
  spawn "killall polybar"

  spawnOnce "lxsession"
  -- spawnOnce "picom"
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  spawnOnce "flameshot"
  spawnOnce "blueman-applet"
  spawnOnce "xcompmgr"
  spawnOnce "mpd"
  -- spawn "sxhkd"
  spawnOnce "insync start"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
  -- spawnOnce "/usr/lib/slack/slack"
  -- spawnOnce "xfce4-pulseaudio-plugin"
  -- spawnOnce "light-locker"

  spawn "setxkbmap -layout us,ru -option 'grp:win_space_toggle'"
  -- spawn "/usr/bin/emacs --daemon" -- emacs daemon for the emacsclient
  -- spawn "polybar-xmonad"
  spawn "$HOME/.config/polybar/launch.sh"
  spawn "$HOME/.config/conky/widgets-startup.sh"

  spawnOnce "xfce4-power-manager"
  spawnOnce "xfce4-clipman"
  spawnOnce "xsetroot -cursor_name Capitaine Cursors - White"
  spawnOnce "input-remapper-control --command autoload"

  -- spawnOnce "sleep 2 && xmonad --restart"
  -- spawnOnce "xargs xwallpaper --stretch < ~/.cache/wall"
  -- spawnOnce "~/.fehbg &"  -- set last saved feh wallpaper
  spawnOnce "feh --bg-fill $HOME/Backgrounds/desktop.png"  -- feh set random wallpaper
  -- spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
  
  setDefaultCursor xC_left_ptr -- Fix cursor theme
  setWMName "LG3D"

myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
 where navKeyMap = M.fromList [
          ((0,xK_Escape), cancel)
         ,((0,xK_Return), select)
         ,((0,xK_slash) , substringSearch myNavigation)
         ,((0,xK_Left)  , move (-1,0)  >> myNavigation)
         ,((0,xK_h)     , move (-1,0)  >> myNavigation)
         ,((0,xK_Right) , move (1,0)   >> myNavigation)
         ,((0,xK_l)     , move (1,0)   >> myNavigation)
         ,((0,xK_Down)  , move (0,1)   >> myNavigation)
         ,((0,xK_j)     , move (0,1)   >> myNavigation)
         ,((0,xK_Up)    , move (0,-1)  >> myNavigation)
         ,((0,xK_k)     , move (0,-1)  >> myNavigation)
         ,((0,xK_y)     , move (-1,-1) >> myNavigation)
         ,((0,xK_i)     , move (1,-1)  >> myNavigation)
         ,((0,xK_n)     , move (-1,1)  >> myNavigation)
         ,((0,xK_m)     , move (1,-1)  >> myNavigation)
         ,((0,xK_space) , setPos (0,0) >> myNavigation)
         ]
       navDefaultHandler = const myNavigation


myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                (0x28,0x2c,0x34) -- lowest inactive bg
                (0x28,0x2c,0x34) -- highest inactive bg
                (0xc7,0x92,0xea) -- active bg
                (0xc0,0xa7,0x9a) -- inactive fg
                (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_navigate    = myNavigation
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 180
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

runSelectedAction' :: GSConfig (X ()) -> [(String, X ())] -> X ()
runSelectedAction' conf actions = do
    selectedActionM <- gridselect conf actions
    case selectedActionM of
        Just selectedAction -> selectedAction
        Nothing -> return ()

-- gsCategories =
--   [ ("Work",      spawnSelected' gsWork)
--   --, ("Education",   spawnSelected' gsEducation)
--   , ("Internet",   spawnSelected' gsInternet)
--   , ("Multimedia", spawnSelected' gsMultimedia)
--   , ("Office",     spawnSelected' gsOffice)
--   , ("Settings",   spawnSelected' gsSettings)
--   , ("System",     spawnSelected' gsSystem)
--   , ("Utilities",  spawnSelected' gsUtilities)
--   ]

gsCategories =
  [ ("Work",      "xdotool key super+alt+1")
  , ("Internet",   "xdotool key super+alt+2")
  , ("Education",  "xdotool key super+alt+3")
  , ("Multimedia", "xdotool key super+alt+4")
  , ("Office",     "xdotool key super+alt+5")
  , ("Settings",   "xdotool key super+alt+6")
  , ("System",     "xdotool key super+alt+7")
  , ("Utilities",  "xdotool key super+alt+8")
  ]

gsWork =
  [ ("FF developer edition", "firefox-developer-edition")
  , ("Brave Nightly", "brave-browser-nightly")
  , ("Chromium", "chromium")
  , ("Slack", "slack")
  , ("Thunderbird", "thunderbird")
  , ("Postman", "postman")
  , ("Discord", "discord")
  , ("Webstorm", "webstorm")
  , ("Idea", "idea")
  , ("Bitwarden", "bitwarden-desktop")
  , ("Epiphany", "epiphany")
  , ("Thunar", "thunar")
  ]

gsInternet =
  [ ("Brave", "brave")
  , ("Discord", "discord")
  , ("Telegram", "telegram-desktop")
  , ("Element", "element-desktop")
  , ("Firefox", "firefox")
  , ("LBRY App", "lbry")
  , ("Mailspring", "mailspring")
  , ("Nextcloud", "nextcloud")
  , ("Qutebrowser", "qutebrowser")
  , ("Transmission", "transmission-gtk")
  , ("Zoom", "zoom")
  , ("Steam", "steam")
  , ("Deluge", "deluge")
  ]

gsEducation =
  [ ("GCompris", "gcompris-qt")
  , ("Kstars", "kstars")
  , ("Minuet", "minuet")
  , ("Scratch", "scratch")
  ]

gsMultimedia =
  [ ("Audacity", "audacity")
  , ("Audacious", "audacious")
  , ("Blender", "blender")
  , ("Deadbeef", "deadbeef")
  , ("Kdenlive", "kdenlive")
  , ("OBS Studio", "obs")
  , ("VLC", "vlc")
  ]

gsOffice =
  [ ("Document Viewer", "evince")
  , ("LibreOffice", "libreoffice")
  , ("LO Base", "lobase")
  , ("LO Calc", "localc")
  , ("LO Draw", "lodraw")
  , ("LO Impress", "loimpress")
  , ("LO Math", "lomath")
  , ("LO Writer", "lowriter")
  ]

gsSettings =
  [ ("ARandR", "arandr")
  , ("ArchLinux Tweak Tool", "archlinux-tweak-tool")
  , ("Customize Look and Feel", "lxappearance")
  , ("Firewall Configuration", "sudo gufw")
  ]

gsSystem =
  [ ("Ghostty", "ghostty")
  , ("Bash", (myTerminal ++ " -e bash"))
  , ("Htop", (myTerminal ++ " -e htop"))
  , ("Fish", (myTerminal ++ " -e fish"))
  , ("PCManFM", "pcmanfm")
  , ("VirtualBox", "virtualbox")
  , ("Virt-Manager", "virt-manager")
  , ("Zsh", (myTerminal ++ " -e zsh"))
  ]

gsUtilities =
  [ ("Emacs", "emacs")
  , ("Emacsclient", "emacsclient -c -a 'emacs'")
  , ("Nitrogen", "nitrogen")
  , ("Vim", (myTerminal ++ " -e vim"))
  ]

gsReload = 
  [ ("T480", "$HOME/.config/polybar/launch-t480.sh")
  , ("T480 single monitor", "$HOME/.config/polybar/launch-t480-single-monitor.sh")
  , ("T480 dual monitor", "$HOME/.config/polybar/launch-t480-dual-monitor.sh")
  ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ limitWindows 5
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ simplestFloat
grid     = renamed [Replace "grid"]
           $ limitWindows 9
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ limitWindows 9
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ limitWindows 7
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ limitWindows 7
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabConfig
tallAccordion  = renamed [Replace "tallAccordion"]
           $ Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color15
}

myTabConfig = def { fontName           = myFont
                 , activeColor         = color13
                 , inactiveColor       = color08
                 , activeBorderColor   = color13
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = colorBack
}

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:Ubuntu:bold:size=60"
  , swn_fade              = 1.0
  , swn_bgcolor           = "#1c1f24"
  , swn_color             = "#ffffff"
  }

-- The layout hook
myLayoutHook = avoidStruts
               $ mouseResize
               $ windowArrange
               $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout = withBorder myBorderWidth tall
                                           ||| noBorders monocle
                                           ||| floats
                                           ||| noBorders tabs
                                           ||| grid
                                           ||| spirals
                                           ||| threeCol
                                           ||| threeRow
                                           ||| tallAccordion
                                           ||| wideAccordion

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
-- myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ className  =? "confirm"                             --> doFloat
  , className  =? "mpv"                                 --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
  , className  =? "file_progress"                       --> doFloat
  , className  =? "dialog"                              --> doFloat
  , className  =? "download"                            --> doFloat
  , className  =? "error"                               --> doFloat
  , className  =? "Gimp"                                --> doFloat
  , title      =? "Peek"                                --> doFloat
  , className  =? "notification"                        --> doFloat
  , className  =? "pinentry-gtk-2"                      --> doFloat
  , className  =? "splash"                              --> doFloat
  , className  =? "toolbar"                             --> doFloat
  , className  =? "Yad"                                 --> doCenterFloat
  , title      =? "Oracle VM VirtualBox Manager"        --> doFloat
  , title      =? "Order Chain - Market Snapshots"      --> doFloat
  , className  =? "Slack Desktop"                       --> doShift ( myWorkspaces !! 0 )
  , className  =? "Chromium"                            --> doShift ( myWorkspaces !! 5 )
  , className  =? "steam"                               --> doShift ( myWorkspaces !! 4 )
  , title      =? "steam"                               --> doShift ( myWorkspaces !! 4 )
  , title      =? "discord"                             --> doShift ( myWorkspaces !! 9 )
  , className  =? "Discord"                             --> doShift ( myWorkspaces !! 9 )
  , className  =? "Audacious"                           --> doShift ( myWorkspaces !! 8 )
  , title      =? "audacious"                           --> doShift ( myWorkspaces !! 8 )
  , className  =? "Slack"                               --> doShift ( myWorkspaces !! 0 )
  , title      =? "Mozilla Firefox Developer Edition"   --> doShift ( myWorkspaces !! 6 )
  , title      =? "Mozilla Firefox"                     --> doShift ( myWorkspaces !! 8 )
  , className  =? "Emacs"                               --> doShift ( myWorkspaces !! 1 )
  , className  =? "Brave-browser-nightly"               --> doShift ( myWorkspaces !! 5 )
  , className  =? "mpv"                                 --> doShift ( myWorkspaces !! 7 )
  , className  =? "Gimp"                                --> doShift ( myWorkspaces !! 8 )
  , className  =? "VirtualBox Manager"                  --> doShift ( myWorkspaces !! 4 )
  , (className =? "firefox" <&&> resource =? "Dialog")  --> doFloat  -- Float Firefox Dialog
  , (className =? "firefox" <&&> resource =? "Toolkit") --> doFloat -- firefox pip
  , isFullscreen                                        --> doFullFloat
  ] <+> namedScratchpadManageHook myScratchPads

subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper
                      $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
    sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe $ "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
  --hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  --(subtitle "Custom Keys":) $ mkNamedKeymap c $
  let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
  subKeys "Xmonad Essentials"
  [ ("M-C-r",        addName "Recompile XMonad"       $ spawn "xmonad --recompile")
  , ("M-S-r",        addName "Restart XMonad"         $ spawn "xmonad --restart")
  , ("M-C-x",        addName "Xrandr reload"          $ spawnSelected' gsReload)
  , ("M-S-q",        addName "Quit XMonad"            $ spawn "~/.config/rofi/powermenu/style-3/powermenu.sh")
  , ("M-S-c",        addName "Kill focused window"    $ kill1)
  , ("M-C-t",        addName "Toggle keyboard layout" $ spawn "setxkbmap -layout us,ru -option 'grp:win_space_toggle'")
  , ("M-S-a",        addName "Kill all windows on WS" $ killAll)
  , ("M-S-<Return>", addName "Run prompt"             $ spawn "rofi -show combi")
  , ("M-S-l",        addName "Run brigness selector"  $ spawn "~/.config/rofi/applets/bin/brightness.sh")
  , ("M-S-/",        addName "Run quick selector"     $ spawn "~/.config/rofi/applets/bin/quicklinks.sh")
  , ("M-S-b",        addName "Toggle bar show/hide"   $ sendMessage ToggleStruts)]

  ^++^ subKeys "Switch to workspace"
  [ ("M-1", addName "Switch to workspace 1"      $ (windows $ W.greedyView $ myWorkspaces !! 0))
  , ("M-2", addName "Switch to workspace 2"      $ (windows $ W.greedyView $ myWorkspaces !! 1))
  , ("M-3", addName "Switch to workspace 3"      $ (windows $ W.greedyView $ myWorkspaces !! 2))
  , ("M-4", addName "Switch to workspace 4"      $ (windows $ W.greedyView $ myWorkspaces !! 3))
  , ("M-5", addName "Switch to workspace 5"      $ (windows $ W.greedyView $ myWorkspaces !! 4))
  , ("M-6", addName "Switch to workspace 6"      $ (windows $ W.greedyView $ myWorkspaces !! 5))
  , ("M-7", addName "Switch to workspace 7"      $ (windows $ W.greedyView $ myWorkspaces !! 6))
  , ("M-8", addName "Switch to workspace 8"      $ (windows $ W.greedyView $ myWorkspaces !! 7))
  , ("M-9", addName "Switch to workspace 9"      $ (windows $ W.greedyView $ myWorkspaces !! 8))
  , ("M-0", addName "Switch to workspace 10"     $ (windows $ W.greedyView $ myWorkspaces !! 9))]

  ^++^ subKeys "Send window to workspace"
  [ ("M-S-1", addName "Send to workspace 1"      $ (windows $ W.shift $ myWorkspaces !! 0))
  , ("M-S-2", addName "Send to workspace 2"      $ (windows $ W.shift $ myWorkspaces !! 1))
  , ("M-S-3", addName "Send to workspace 3"      $ (windows $ W.shift $ myWorkspaces !! 2))
  , ("M-S-4", addName "Send to workspace 4"      $ (windows $ W.shift $ myWorkspaces !! 3))
  , ("M-S-5", addName "Send to workspace 5"      $ (windows $ W.shift $ myWorkspaces !! 4))
  , ("M-S-6", addName "Send to workspace 6"      $ (windows $ W.shift $ myWorkspaces !! 5))
  , ("M-S-7", addName "Send to workspace 7"      $ (windows $ W.shift $ myWorkspaces !! 6))
  , ("M-S-8", addName "Send to workspace 8"      $ (windows $ W.shift $ myWorkspaces !! 7))
  , ("M-S-9", addName "Send to workspace 9"      $ (windows $ W.shift $ myWorkspaces !! 8))
  , ("M-S-0", addName "Switch to workspace 10"   $ (windows $ W.shift $ myWorkspaces !! 9))]

  ^++^ subKeys "Move window to WS and go there"
  [ ("M-S-<Page_Up>", addName "Move window to next WS"   $ shiftTo Next nonNSP >> moveTo Next nonNSP)
  , ("M-S-<Page_Down>", addName "Move window to prev WS" $ shiftTo Prev nonNSP >> moveTo Prev nonNSP)]

  ^++^ subKeys "Window navigation"
  [ ("M-j", addName "Move focus to next window"                $ windows W.focusDown)
  , ("M-k", addName "Move focus to prev window"                $ windows W.focusUp)
  , ("M-m", addName "Move focus to master window"              $ windows W.focusMaster)
  , ("M-S-j", addName "Swap focused window with next window"   $ windows W.swapDown)
  , ("M-S-k", addName "Swap focused window with prev window"   $ windows W.swapUp)
  , ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster)
  , ("M-<Backspace>", addName "Move focused window to master"  $ promote)
  , ("M-S-,", addName "Rotate all windows except master"       $ rotSlavesDown)
  , ("M-S-.", addName "Rotate all windows current stack"       $ rotAllDown)]

  ^++^ subKeys "Dmenu scripts"
  [ ("M-p h", addName "List all dmscripts"     $ spawn "dm-hub")
  -- , ("M-p a", addName "Choose ambient sound"   $ spawn "dm-sounds")
  -- , ("M-p b", addName "Set background"         $ spawn "dm-setbg")
  -- , ("M-p c", addName "Choose color scheme"    $ spawn "~/.local/bin/dtos-colorscheme")
  -- , ("M-p C", addName "Pick color from scheme" $ spawn "dm-colpick")
  -- , ("M-p e", addName "Edit config files"      $ spawn "dm-confedit")
  -- , ("M-p k", addName "Kill processes"         $ spawn "dm-kill")
  -- , ("M-p m", addName "View manpages"          $ spawn "dm-man")
  -- , ("M-p n", addName "Store and copy notes"   $ spawn "dm-note")
  -- , ("M-p o", addName "Browser bookmarks"      $ spawn "dm-bookman")
  -- , ("M-p q", addName "Logout Menu"            $ spawn "dm-logout")
  , ("M-p p", addName "Screenshot"             $ spawn "flameshot gui")
  , ("M-p t", addName "Thunar"                 $ spawn "thunar")
  , ("M-p v", addName "Peek video"             $ spawn "peek")]

  ^++^ subKeys "Favorite programs"
  [ ("M-<Return>", addName "Launch terminal"   $ spawn (myTerminal))
  , ("M-b", addName "Launch web browser"       $ spawn (myBrowser))
  , ("M-M1-h", addName "Launch htop"           $ spawn (myTerminal ++ " -e htop"))]

  ^++^ subKeys "Monitors"
  [ ("M-.", addName "Switch focus to next monitor" $ nextScreen)
  , ("M-,", addName "Switch focus to prev monitor" $ prevScreen)]

  -- Switch layouts
  ^++^ subKeys "Switch layouts"
  [ ("M-<Tab>", addName "Switch to next layout"   $ sendMessage NextLayout)
  , ("M-<Space>", addName "Do nothing"   $ spawn "test")
  , ("M-S-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)]

  -- Window resizing
  ^++^ subKeys "Window resizing"
  [ ("M-h", addName "Shrink window"               $ sendMessage Shrink)
  , ("M-l", addName "Expand window"               $ sendMessage Expand)
  , ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink)
  , ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)]

  -- Floating windows
  ^++^ subKeys "Floating windows"
  [ ("M-f", addName "Toggle float layout"        $ sendMessage (T.Toggle "floats"))
  , ("M-t", addName "Sink a floating window"     $ withFocused $ windows . W.sink)
  , ("M-S-t", addName "Sink all floated windows" $ sinkAll)]

  -- Increase/decrease spacing (gaps)
  ^++^ subKeys "Window spacing (gaps)"
  [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4)
  , ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4)
  , ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4)
  , ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)]

  -- Increase/decrease windows in the master pane or the stack
  ^++^ subKeys "Increase/decrease windows in master pane or the stack"
  [ ("M-S-<Up>", addName "Increase clients in master pane"   $ sendMessage (IncMasterN 1))
  , ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1)))
  , ("M-=", addName "Increase max # of windows for layout"   $ increaseLimit)
  , ("M--", addName "Decrease max # of windows for layout"   $ decreaseLimit)]

  -- Sublayouts
  -- This is used to push windows to tabbed sublayouts, or pull them out of it.
  ^++^ subKeys "Sublayouts"
  [ ("M-C-h", addName "pullGroup L"           $ sendMessage $ pullGroup L)
  , ("M-C-l", addName "pullGroup R"           $ sendMessage $ pullGroup R)
  , ("M-C-k", addName "pullGroup U"           $ sendMessage $ pullGroup U)
  , ("M-C-j", addName "pullGroup D"           $ sendMessage $ pullGroup D)
  , ("M-C-m", addName "MergeAll"              $ withFocused (sendMessage . MergeAll))
  -- , ("M-C-u", addName "UnMerge"               $ withFocused (sendMessage . UnMerge))
  , ("M-C-/", addName "UnMergeAll"            $  withFocused (sendMessage . UnMergeAll))
  , ("M-C-.", addName "Switch focus next tab" $  onGroup W.focusUp')
  , ("M-C-,", addName "Switch focus prev tab" $  onGroup W.focusDown')]

  -- Scratchpads
  -- Toggle show/hide these programs. They run on a hidden workspace.
  -- When you toggle them to show, it brings them to current workspace.
  -- Toggle them to hide and it sends them back to hidden workspace (NSP).
  ^++^ subKeys "Scratchpads"
  [ ("M-s t", addName "Toggle scratchpad terminal"        $ namedScratchpadAction myScratchPads "terminal")
  , ("M-s m", addName "Toggle scratchpad mocp"            $ namedScratchpadAction myScratchPads "mocp")
  , ("M-<Escape>", addName "Toggle scratchpad calculator" $ namedScratchpadAction myScratchPads "calculator")]

  -- Controls for mocp music player (SUPER-u followed by a key)
  ^++^ subKeys "Mocp music player"
  [ ("M-u p", addName "mocp play"                $ spawn "mocp --play")
  , ("M-u l", addName "mocp next"                $ spawn "mocp --next")
  , ("M-u h", addName "mocp prev"                $ spawn "mocp --previous")
  , ("M-u a", addName "copy to all worspaces"    $ windows copyToAll)
  , ("M-u c", addName "kill all copies"          $ killAllOtherCopies)
  , ("M-u k", addName "kill all"                 $ kill1)
  , ("M-u f", addName "mocp toggle pause"  $ spawn "mocp --toggle-pause")]


  ^++^ subKeys "GridSelect"
  -- , ("C-g g", addName "Select favorite apps"     $ runSelectedAction' defaultGSConfig gsCategories)
  [ ("M-M1-<Return>", addName "Select favorite apps" $ spawnSelected'
       $ gsWork ++ gsEducation ++ gsInternet ++ gsMultimedia ++ gsOffice ++ gsSettings ++ gsSystem ++ gsUtilities)
  , ("M-M1-c", addName "Select favorite apps"    $ spawnSelected' gsCategories)
  , ("M-M1-t", addName "Goto selected window"    $ goToSelected $ mygridConfig myColorizer)
  , ("M-M1-b", addName "Bring selected window"   $ bringSelected $ mygridConfig myColorizer)
  , ("M-M1-1", addName "Menu of work"            $ spawnSelected' gsWork)
  , ("M-M1-2", addName "Menu of Internet apps"   $ spawnSelected' gsInternet)
  , ("M-M1-3", addName "Menu of education apps"  $ spawnSelected' gsEducation)
  , ("M-M1-4", addName "Menu of multimedia apps" $ spawnSelected' gsMultimedia)
  , ("M-M1-5", addName "Menu of office apps"     $ spawnSelected' gsOffice)
  , ("M-M1-6", addName "Menu of settings apps"   $ spawnSelected' gsSettings)
  , ("M-M1-7", addName "Menu of system apps"     $ spawnSelected' gsSystem)
  , ("M-M1-8", addName "Menu of utilities apps"  $ spawnSelected' gsUtilities)]

  -- Emacs (SUPER-e followed by a key)
  ^++^ subKeys "Emacs"
  [("M-e e", addName "Emacsclient"               $ spawn (myEmacs))
  -- ("M-e e", addName "Emacsclient Dashboard"    $ spawn (myEmacs ++ ("--eval '(dashboard-refresh-buffer)'")))
  , ("M-e a", addName "Emacsclient EMMS (music)" $ spawn (myEmacs ++ ("--eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/\")'")))
  , ("M-e b", addName "Emacsclient Ibuffer"      $ spawn (myEmacs ++ ("--eval '(ibuffer)'")))
  , ("M-e d", addName "Emacsclient Dired"        $ spawn (myEmacs ++ ("--eval '(dired nil)'")))
  , ("M-e i", addName "Emacsclient ERC (IRC)"    $ spawn (myEmacs ++ ("--eval '(erc)'")))
  , ("M-e n", addName "Emacsclient Elfeed (RSS)" $ spawn (myEmacs ++ ("--eval '(elfeed)'")))
  , ("M-e s", addName "Emacsclient Eshell"       $ spawn (myEmacs ++ ("--eval '(eshell)'")))
  , ("M-e v", addName "Emacsclient Vterm"        $ spawn (myEmacs ++ ("--eval '(+vterm/here nil)'")))
  , ("M-e w", addName "Emacsclient EWW Browser"  $ spawn (myEmacs ++ ("--eval '(doom/window-maximize-buffer(eww \"distro.tube\"))'")))]

  -- Multimedia Keys
  ^++^ subKeys "Multimedia keys"
  [ ("<XF86AudioPlay>", addName "mocp play"           $ spawn "mocp --play")
  , ("<XF86AudioPrev>", addName "mocp next"           $ spawn "mocp --previous")
  , ("<XF86AudioNext>", addName "mocp prev"           $ spawn "mocp --next")
  , ("<XF86AudioMute>", addName "Toggle audio mute"   $ spawn "amixer set Master toggle")
  , ("<XF86AudioLowerVolume>", addName "Lower vol"    $ spawn "amixer set Master 5%- unmute")
  , ("<XF86AudioRaiseVolume>", addName "Raise vol"    $ spawn "amixer set Master 5%+ unmute")
  , ("<XF86HomePage>", addName "Open home page"       $ spawn (myBrowser ++ " https://www.youtube.com/c/DistroTube"))
  , ("<XF86Search>", addName "Web search (dmscripts)" $ spawn "dm-websearch")
  , ("<XF86Mail>", addName "Email client"             $ runOrRaise "thunderbird" (resource =? "thunderbird"))
  , ("<XF86Calculator>", addName "Calculator"         $ runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
  , ("<XF86Eject>", addName "Eject /dev/cdrom"        $ spawn "eject /dev/cdrom")
  , ("<Print>", addName "Take screenshot (dmscripts)" $ spawn "dm-maim")
  ]
  -- The following lines are needed for named scratchpads.
    where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
          nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.9

main :: IO ()
main = do

  xmonad $ addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $ docks . ewmh $ def
    { manageHook         = myManageHook <+> manageDocks
    , handleEventHook    = windowedFullscreenFixEventHook <> swallowEventHook (className =? "Alacritty"  <||> className =? "st-256color" <||> className =? "XTerm") (return True) <> trayerPaddingXmobarEventHook
    , modMask            = myModMask
    , logHook            = myLogHook
    , terminal           = myTerminal
    , startupHook        = myStartupHook
    , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
    }
