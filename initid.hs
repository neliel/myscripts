#!/usr/bin/env runhaskell
{-# LANGUAGE OverloadedStrings #-}

--  initid.hs
--  02.08.2013

import System.Cmd    (rawSystem)
import Graphics.UI.Gtk
import Graphics.UI.Gtk.Builder
import Data.Maybe.Utils
import Data.Time
import Data.Monoid ((<>))
import System.Random

data Identity = Identity
    { name     :: String
    , lastname :: String
    , sex      :: String
    }


writeID :: Identity -> IO ()
writeID ido = do
    c    <- getCurrentTime
    rpc  <- getStdGen
    let
        (y,m,d)       = toGregorian $ utctDay c
        file          = foldl (<>) [] [name ido, "_", lastname ido, ".idt"]
        (cp, g)       = randomR (42000::Int, 42999) rpc
        tel           = take 8 $ randomRs ('0', '1') g
        (bday, bdg)   = randomR (1::Int, 30) g
        (bmonth, bmg) = randomR (1::Int, 12) bdg
        (byear, byg)  = randomR ((fromInteger (y - 50))::Int, fromInteger (y - 20)) bmg
        str           = unlines
            [ "-- " <> file
            , foldl (<>) [] ["-- ", show d, ".", show m, ".", show y]
            , ""
            , "NAME " <> name ido
            , "LASTNAME " <> lastname ido
            , "BIRTHDAY " <> foldl (<>) [] [show bday, ".", show bmonth, ".", show byear]
            , "SEX " <> sex ido
            , "CP " <> show cp
            , "TEL 06" <> tel
            , ""
            , "--eof"
            ]
    writeFile file str

main :: IO ()
main = do
  initGUI
  build <- builderNew
  builderAddFromFile build "initid2.glade"
  mainWindow <- builderGetObject build castToWindow "mainWindow"
  mainWindow `onDestroy` mainQuit
  mQuit <- builderGetObject build castToButton "quit"
  mQuit `onClicked` mainQuit
  -- lets define the text areas
  namee     <- builderGetObject build castToEntry "name"
  lastnamee <- builderGetObject build castToEntry "lastname"
  sexe      <- builderGetObject build castToComboBox "sex"
  comboBoxSetModelText sexe
  mapM_ (comboBoxAppendText sexe) ["Male", "Female"]
  let
    runAction = do
        namea     <- entryGetText namee
        lastnamea <- entryGetText lastnamee
        sexa      <- comboBoxGetActiveText sexe
        let
            ido = Identity
                { name     = namea
                , lastname = lastnamea
                , sex      = case sexa of
                    Nothing -> ""
                    Just a  -> a
                }
        writeID ido
        mainQuit
  create  <- builderGetObject build castToButton "create"
  create `onClicked` runAction
  widgetShowAll mainWindow
  mainGUI

--eof
