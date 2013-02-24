module Helpers.AES
( encrypt
, encryptToFile
, encryptFromToFile
, decrypt
, decryptFromFile
, decryptFromToFile
) where

import qualified Data.ByteString.Char8        as BS
import qualified Data.ByteString.Lazy.Char8   as BL
import System.Directory
import Codec.Crypto.SimpleAES
import Control.Applicative

key :: String -> IO Key
key k = do
    file <- doesFileExist k
    if file
    then BS.readFile k
    else return $ BS.pack k

encrypt :: String -> BL.ByteString -> IO BL.ByteString
encrypt k bs =
    key k >>= \g -> encryptMsg CBC g bs

decrypt :: String -> BL.ByteString -> IO BL.ByteString
decrypt k bs =
    key k >>= \g -> return $ decryptMsg CBC g bs

encryptToFile :: String -> FilePath -> BL.ByteString -> IO ()
encryptToFile k path bs =
    encrypt k bs >>= BL.writeFile path

encryptFromToFile :: String -> FilePath -> FilePath -> IO ()
encryptFromToFile k sourcePath destPath =
    BL.readFile sourcePath >>= encryptToFile k destPath

decryptFromFile :: String -> FilePath -> IO BL.ByteString
decryptFromFile k path =
    BL.readFile path >>= decrypt k

decryptFromToFile :: String -> FilePath -> FilePath -> IO ()
decryptFromToFile k sourcePath destPath =
    decryptFromFile k sourcePath >>= BL.writeFile destPath

--EOF
