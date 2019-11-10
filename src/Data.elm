module Data exposing (Position, education, experience, skills)


type alias Position =
    { title : String
    , location : String
    , company : String
    , projects : List Project
    , dates : String
    }


type alias Project =
    { name : String
    , start : Int
    , end : Int
    , stack : List String
    , overview : String
    , talkingPoints : List String
    }


type alias Institution =
    { name : String
    , course : String
    , startYear : Int
    , endYear : Int
    }


type alias Skill =
    { name : String
    , rating : Int
    }


experience : List Position
experience =
    [ { title = "Software Developer Consultant"
      , location = "Malmö"
      , company = "ÅF"
      , dates = "2017-present"
      , projects =
            [ { name = "Embedded software developer - Borg Warner"
              , start = 2017
              , end = 2019
              , overview = "Build software for embedded application "
              , stack = [ "C", "AUTOSAR" ]
              , talkingPoints = []
              }
            ]
      }
    ]


education : List Institution
education =
    [ { name = "Lunds Tekniska Högskola"
      , course = "Electrical Engineering"
      , startYear = 2012
      , endYear = 2017
      }
    ]


skills : List Skill
skills =
    [ { name = "Typescript", rating = 8 }
    , { name = "BDD / TDD", rating = 13 }
    , { name = "Git", rating = 10 }
    , { name = "Realtime systems", rating = 5 }
    , { name = "HTML", rating = 12 }
    , { name = "CSS / SASS", rating = 12 }
    , { name = "OO", rating = 14 }
    , { name = "Functional", rating = 3 }
    ]
