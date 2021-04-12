{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{- |
   Module      : Text.Pandoc.Writers.LaTeX.Lang
   Copyright   : Copyright (C) 2006-2021 John MacFarlane
   License     : GNU GPL, version 2 or above

   Maintainer  : John MacFarlane <jgm@berkeley.edu>
   Stability   : alpha
   Portability : portable
-}
module Text.Pandoc.Writers.LaTeX.Lang
  ( toPolyglossiaEnv,
    toPolyglossia,
    toBabel
  ) where
import Data.Text (Text)
import UnicodeCollation.Lang (Lang(..))


-- In environments \Arabic instead of \arabic is used
toPolyglossiaEnv :: Lang -> (Text, Text)
toPolyglossiaEnv l =
  case toPolyglossia l of
    ("arabic", o) -> ("Arabic", o)
    x             -> x

-- Takes a list of the constituents of a BCP47 language code and
-- converts it to a Polyglossia (language, options) tuple
-- http://mirrors.ctan.org/macros/latex/contrib/polyglossia/polyglossia.pdf
toPolyglossia :: Lang -> (Text, Text)
toPolyglossia (Lang "ar" _ (Just "DZ") _ _ _)  = ("arabic", "locale=algeria")
toPolyglossia (Lang "ar" _ (Just "IQ") _ _ _)  = ("arabic", "locale=mashriq")
toPolyglossia (Lang "ar" _ (Just "JO") _ _ _)  = ("arabic", "locale=mashriq")
toPolyglossia (Lang "ar" _ (Just "LB") _ _ _)  = ("arabic", "locale=mashriq")
toPolyglossia (Lang "ar" _ (Just "LY") _ _ _)  = ("arabic", "locale=libya")
toPolyglossia (Lang "ar" _ (Just "MA") _ _ _)  = ("arabic", "locale=morocco")
toPolyglossia (Lang "ar" _ (Just "MR") _ _ _)  = ("arabic", "locale=mauritania")
toPolyglossia (Lang "ar" _ (Just "PS") _ _ _)  = ("arabic", "locale=mashriq")
toPolyglossia (Lang "ar" _ (Just "SY") _ _ _)  = ("arabic", "locale=mashriq")
toPolyglossia (Lang "ar" _ (Just "TN") _ _ _)  = ("arabic", "locale=tunisia")
toPolyglossia (Lang "de" _ _ vars _ _)
  | "1901" `elem` vars                         = ("german", "spelling=old")
toPolyglossia (Lang "de" _ (Just "AT") vars _ _)
  | "1901" `elem` vars         = ("german", "variant=austrian, spelling=old")
toPolyglossia (Lang "de" _ (Just "AT") _ _ _)  = ("german", "variant=austrian")
toPolyglossia (Lang "de" _ (Just "CH") vars _ _)
  | "1901" `elem` vars        = ("german", "variant=swiss, spelling=old")
toPolyglossia (Lang "de" _ (Just "CH") _ _ _) = ("german", "variant=swiss")
toPolyglossia (Lang "de" _ _ _ _ _)           = ("german", "")
toPolyglossia (Lang "dsb" _ _ _ _ _)          = ("lsorbian", "")
toPolyglossia (Lang "el" _ _ vars _ _)
  | "polyton" `elem` vars                     = ("greek",   "variant=poly")
toPolyglossia (Lang "en" _ (Just "AU") _ _ _) = ("english", "variant=australian")
toPolyglossia (Lang "en" _ (Just "CA") _ _ _) = ("english", "variant=canadian")
toPolyglossia (Lang "en" _ (Just "GB") _ _ _) = ("english", "variant=british")
toPolyglossia (Lang "en" _ (Just "NZ") _ _ _) = ("english", "variant=newzealand")
toPolyglossia (Lang "en" _ (Just "UK") _ _ _) = ("english", "variant=british")
toPolyglossia (Lang "en" _ (Just "US") _ _ _) = ("english", "variant=american")
toPolyglossia (Lang "grc" _ _ _ _ _)          = ("greek",   "variant=ancient")
toPolyglossia (Lang "hsb" _ _ _ _ _)          = ("usorbian", "")
toPolyglossia (Lang "la" _ _ vars _ _)
  | "x-classic" `elem` vars                   = ("latin", "variant=classic")
toPolyglossia (Lang "pt" _ (Just "BR") _ _ _) = ("portuguese", "variant=brazilian")
toPolyglossia (Lang "sl" _ _ _ _ _)           = ("slovenian", "")
toPolyglossia x                               = (commonFromBcp47 x, "")

-- Takes a list of the constituents of a BCP47 language code and
-- converts it to a Babel language string.
-- http://mirrors.ctan.org/macros/latex/required/babel/base/babel.pdf
-- List of supported languages (slightly outdated):
-- http://tug.ctan.org/language/hyph-utf8/doc/generic/hyph-utf8/hyphenation.pdf
toBabel :: Lang -> Text
toBabel (Lang "de" _ (Just "AT") vars _ _)
  | "1901" `elem` vars                  = "austrian"
  | otherwise                           = "naustrian"
toBabel (Lang "de" _ (Just "CH") vars _ _)
  | "1901" `elem` vars                  = "swissgerman"
  | otherwise                           = "nswissgerman"
toBabel (Lang "de" _ _ vars _ _)
  | "1901" `elem` vars                  = "german"
  | otherwise                           = "ngerman"
toBabel (Lang "dsb" _ _ _ _ _)          = "lowersorbian"
toBabel (Lang "el" _ _ vars _ _)
  | "polyton" `elem` vars               = "polutonikogreek"
toBabel (Lang "en" _ (Just "AU") _ _ _) = "australian"
toBabel (Lang "en" _ (Just "CA") _ _ _) = "canadian"
toBabel (Lang "en" _ (Just "GB") _ _ _) = "british"
toBabel (Lang "en" _ (Just "NZ") _ _ _) = "newzealand"
toBabel (Lang "en" _ (Just "UK") _ _ _) = "british"
toBabel (Lang "en" _ (Just "US") _ _ _) = "american"
toBabel (Lang "fr" _ (Just "CA") _ _ _) = "canadien"
toBabel (Lang "fra" _ _ vars _ _)
  | "aca" `elem` vars                   = "acadian"
toBabel (Lang "grc" _ _ _ _ _)          = "polutonikogreek"
toBabel (Lang "hsb" _ _ _ _ _)          = "uppersorbian"
toBabel (Lang "la" _ _ vars _ _)
  | "x-classic" `elem` vars             = "classiclatin"
toBabel (Lang "pt" _ (Just "BR") _ _ _) = "brazilian"
toBabel (Lang "sl" _ _ _ _ _)           = "slovene"
toBabel x                               = commonFromBcp47 x

-- Takes a list of the constituents of a BCP47 language code
-- and converts it to a string shared by Babel and Polyglossia.
-- https://tools.ietf.org/html/bcp47#section-2.1
commonFromBcp47 :: Lang -> Text
commonFromBcp47 (Lang "sr" (Just "Cyrl") _ _ _ _)      = "serbianc"
commonFromBcp47 (Lang "zh" (Just "Latn") _ vars _ _)
  | "pinyin" `elem` vars                               = "pinyin"
commonFromBcp47 (Lang l _ _ _ _ _) = fromIso l
  where
    fromIso "af"  = "afrikaans"
    fromIso "am"  = "amharic"
    fromIso "ar"  = "arabic"
    fromIso "as"  = "assamese"
    fromIso "ast" = "asturian"
    fromIso "bg"  = "bulgarian"
    fromIso "bn"  = "bengali"
    fromIso "bo"  = "tibetan"
    fromIso "br"  = "breton"
    fromIso "ca"  = "catalan"
    fromIso "cy"  = "welsh"
    fromIso "cs"  = "czech"
    fromIso "cop" = "coptic"
    fromIso "da"  = "danish"
    fromIso "dv"  = "divehi"
    fromIso "el"  = "greek"
    fromIso "en"  = "english"
    fromIso "eo"  = "esperanto"
    fromIso "es"  = "spanish"
    fromIso "et"  = "estonian"
    fromIso "eu"  = "basque"
    fromIso "fa"  = "farsi"
    fromIso "fi"  = "finnish"
    fromIso "fr"  = "french"
    fromIso "fur" = "friulan"
    fromIso "ga"  = "irish"
    fromIso "gd"  = "scottish"
    fromIso "gez" = "ethiopic"
    fromIso "gl"  = "galician"
    fromIso "he"  = "hebrew"
    fromIso "hi"  = "hindi"
    fromIso "hr"  = "croatian"
    fromIso "hu"  = "magyar"
    fromIso "hy"  = "armenian"
    fromIso "ia"  = "interlingua"
    fromIso "id"  = "indonesian"
    fromIso "ie"  = "interlingua"
    fromIso "is"  = "icelandic"
    fromIso "it"  = "italian"
    fromIso "ja"  = "japanese"
    fromIso "km"  = "khmer"
    fromIso "kmr" = "kurmanji"
    fromIso "kn"  = "kannada"
    fromIso "ko"  = "korean"
    fromIso "la"  = "latin"
    fromIso "lo"  = "lao"
    fromIso "lt"  = "lithuanian"
    fromIso "lv"  = "latvian"
    fromIso "ml"  = "malayalam"
    fromIso "mn"  = "mongolian"
    fromIso "mr"  = "marathi"
    fromIso "nb"  = "norsk"
    fromIso "nl"  = "dutch"
    fromIso "nn"  = "nynorsk"
    fromIso "no"  = "norsk"
    fromIso "nqo" = "nko"
    fromIso "oc"  = "occitan"
    fromIso "pa"  = "panjabi"
    fromIso "pl"  = "polish"
    fromIso "pms" = "piedmontese"
    fromIso "pt"  = "portuguese"
    fromIso "rm"  = "romansh"
    fromIso "ro"  = "romanian"
    fromIso "ru"  = "russian"
    fromIso "sa"  = "sanskrit"
    fromIso "se"  = "samin"
    fromIso "sk"  = "slovak"
    fromIso "sq"  = "albanian"
    fromIso "sr"  = "serbian"
    fromIso "sv"  = "swedish"
    fromIso "syr" = "syriac"
    fromIso "ta"  = "tamil"
    fromIso "te"  = "telugu"
    fromIso "th"  = "thai"
    fromIso "ti"  = "ethiopic"
    fromIso "tk"  = "turkmen"
    fromIso "tr"  = "turkish"
    fromIso "uk"  = "ukrainian"
    fromIso "ur"  = "urdu"
    fromIso "vi"  = "vietnamese"
    fromIso _     = ""
