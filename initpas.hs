#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-}

--  initpas.hs
--  02.08.2013

import Graphics.UI.Gtk
import Graphics.UI.Gtk.Builder
import Data.Time
import Data.Char           (toLower)
import System.Directory    (getHomeDirectory)
import Data.Monoid         ((<>))
import Control.Applicative ((<$>))

data Identity = Identity
    { title    :: String
    , user     :: String
    , password :: String
    , onana    :: String
    , comment  :: String
    }


writeID :: Identity -> IO ()
writeID ido = do
    c    <- getCurrentTime
    let
        (y,m,d)       = toGregorian $ utctDay c
        file          = title ido <> ".mli"
        str           = unlines
            [ "-- " <> file
            , foldl (<>) [] ["-- ", show d, ".", show m, ".", show y]
            , ""
            , "USER " <> user ido
            , "PASSWORD " <> password ido
            , "ON " <> onana ido
            , comment ido
            , ""
            , "--eof"
            ]
    writeFile file str

main :: IO ()
main = do
  home <- getHomeDirectory
  initGUI
  build <- builderNew
  builderAddFromFile build "initpas.glade"
  mainWindow <- builderGetObject build castToWindow "mainWindow"
  pix        <- pixbufNewFromFile (home <> "/.opt/img/initpas_fav.png")
  windowSetIcon mainWindow $ Just pix
  mainWindow `onDestroy` mainQuit
  mQuit <- builderGetObject build castToButton "quit"
  mQuit `onClicked` mainQuit
  -- lets define the text areas
  titlee    <- builderGetObject build castToEntry "title"
  usere     <- builderGetObject build castToEntry "user"
  passworde <- builderGetObject build castToEntry "password"
  onanae    <- builderGetObject build castToEntry "on"
  commente  <- builderGetObject build castToEntry "comment"
  let
    runAction = do
        titlea    <- entryGetText titlee
        usera     <- entryGetText usere
        passworda <- entryGetText passworde
        onanaa    <- entryGetText onanae
        commenta  <- entryGetText commente
        let
            ido = Identity
                { title    = toLower <$> titlea
                , user     = usera
                , password = passworda
                , onana    = onanaa
                , comment  = commenta
                }
        writeID ido
        mainQuit
  create  <- builderGetObject build castToButton "create"
  create `onClicked` runAction
  widgetShowAll mainWindow
  mainGUI

--eof

