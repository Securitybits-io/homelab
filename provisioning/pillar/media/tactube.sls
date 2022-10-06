mounts:
  mounted:
    YoutubeDLMovies:
      name: /youtube-dl
      device: //10.0.11.241/PlexMedia/Youtube-DL
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,username=guest,password="",vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True

cron:
  minute: 0
  hour: 2

youtubedl:
  folder: TacTube
  channels:
    GBRSGroup:
      channel: "GBRSGroup"
      url: "https://www.youtube.com/c/GBRSGroup/videos"
    TribeSk8tz:
      channel: "TribeSk8tz"
      url: "https://www.youtube.com/c/TRIBESK8Z/videos"
    SCIrregulars:
      channel: "SCIrregulars"
      url: "https://www.youtube.com/c/SladeIrregulars1984/videos"
    Jerelaja:
      channel: "Jerelaja"
      url: "https://www.youtube.com/user/jerelaaja/videos"
    InvisioCommunication:
      channel: "InvisioCommunication"
      url: "https://www.youtube.com/user/INVISIOCOMMUNICATION"
    FerroConcepts:
      channel: "FerroConcepts"
      url: "https://www.youtube.com/channel/UCWcq7YsS5kFVU9uMcAc0fmA"
    ForwardObservationsGroup:
      channel: "ForwardObservationsGroup"
      url: "https://www.youtube.com/channel/UCA2BX6VwUnaOhxzrxgwK0Ag"
    ForwardObservationsGroupArchive:
      channel: "ForwardObservationsGroupArchive"
      url: "https://www.youtube.com/c/ForwardObservationsArchives/videos"
    SpiritusSystems:
      channel: "SpiritusSystems"
      url: "https://www.youtube.com/c/SpiritusSystems"
    ScimitarMilsim:
      channel: "ScimitarMilsim"
      url: "https://www.youtube.com/channel/UCjCeT3Z2nv3VM0WzjhvsYXQ"
    Weapon Snatcher:
      channel: "Weapon Snatcher"
      url: "https://www.youtube.com/c/WeaponSnatcher/videos"
    CobaltMilsim:
      channel: "CobaltMilsim"
      url: "https://www.youtube.com/user/CobaltMilsim"
    HighReadyClips:
      channel: "HighReadyClips"
      url: "https://www.youtube.com/user/HighReadyClips/videos"
    MilsimMedia:
      channel: "MilsimMedia"
      url: "https://www.youtube.com/c/MilsimMedia"
    Stirling Airsoft:
      channel: "Stirling Airsoft"
      url: "https://www.youtube.com/channel/UC-E4WxDCMhcgpres-pCcg6g"
    HumbleBoysAirsoft:
      channel: "HumbleBoysAirsoft"
      url: "https://www.youtube.com/channel/UCRlu5wV-dxGTUa-aXZg0eKQ"
    Midwest Development Group:
      channel: "Midwest Development Group"
      url: "https://www.youtube.com/channel/UC6m6LZmjl8_75ZPwd0TzJHQ"
    Musat:
      channel: "Musat"
      url: "https://www.youtube.com/c/MUSATInc"
    NSWGroup:
      channel: "NSWGroup"
      url: "https://www.youtube.com/user/dfmbatera/videos"
    POChannel:
      channel: "POChannel"
      url: "https://www.youtube.com/channel/UCAsh8YGJyhnRW4v629R-AeQ"
    USASOC:
      channel: "USASOC"
      url: "https://www.youtube.com/c/USASOAC/videos"
    TimesArchive:
      channel: "TimesArchive"
      url: "https://www.youtube.com/c/TimesArchives"
    MilspecMojo:
      channel: "MilspecMojo"
      url: "https://www.youtube.com/channel/UC3b0hycqWaTpbonOk021Bow"
    SuperFlex:
      channel: "SuperFlex"
      url: "https://www.youtube.com/channel/UCcvhFFkUKfMAc7HBrCojIOA/videos"
    GarandThumb:
      channel: "GarandThumb"
      url: "https://www.youtube.com/c/GarandThumb/videos"
    Administrative Results:
      channel: "Administrative Results"
      url: "https://www.youtube.com/c/AdministrativeResults/videos"
    ProjectGecko:
      channel: "ProjectGecko"
      url: "https://www.youtube.com/c/ProjectGecko/videos"
    HighEndPew:
      channel: "HighEndPew"
      url: "https://www.youtube.com/c/HighEndPew/videos"
    4thleafgroup:
      channel: "4thleafgroup"
      url: "https://www.youtube.com/c/4thLeafGroup/videos"
    BESTAAirsoft:
      channel: "BESTAAirsoft"
      url: "https://www.youtube.com/c/BESTAAirsoft/videos"
    Condition One Group:
      channel: "Condition One Group"
      url: "https://www.youtube.com/channel/UC-K-QXfuONACYb9C1iYMA4A/videos"
    Iron Infidel:
      channel: "Iron Infidel"
      url: "https://www.youtube.com/c/IronInfidel/videos"
    Wise Men Company:
      channel: "Wise Men Company"
      url: "https://www.youtube.com/c/Wisemencompany77/videos"
    Kit Badger:
      channel: "Kit Badger"
      url: "https://www.youtube.com/c/KitBadger/videos"
    Brent0331:
      channel: "Brent0331"
      url: "https://www.youtube.com/user/Brent0331/videos"
    theFieldCraftSurvivalChannel:
      channel: "theFieldCraftSurvivalChannel"
      url: "https://www.youtube.com/c/TheFieldCraftSurvivalChannel/videos"
    Mike Glover Actual:
      channel: "Mike Glover Actual"
      url: "https://www.youtube.com/c/MikeGloverActual"
    S2 Underground:
      channel: "S2 Underground"
      url: "https://www.youtube.com/c/S2Underground/videos"
    Tactical Hyve:
      channel: "Tactical Hyve"
      url: "https://www.youtube.com/c/TacticalHyve/videos"
    UF Pro:
      channel: "UF Pro"
      url: "https://www.youtube.com/c/ufprogear/videos"
    Specter Airsoft Team:
      channel: "Specter Airsoft Team"
      url: "https://www.youtube.com/channel/UCjuoFlRx230vijwZ5mq29qQ"
    TREXARMS:
      channel: "TREXARMS"
      url: "https://www.youtube.com/c/TREXARMS"
    TNVCINC:
      channel: "TNVCINC"
      url: "https://www.youtube.com/user/TNVCINC/videos"
    KineticConsulting:
      channel: "KineticConsulting"
      url: "https://www.youtube.com/c/KineticConsulting/videos"
    HaleyStrategicConsulting:
      channel: "HaleyStrategicConsulting"
      url: "https://www.youtube.com/c/HaleyStrategicPartners/videos"
    BarrelAndHatchett:
      channel: "BarrelAndHatchett"
      url: "https://www.youtube.com/channel/UC_RWPmdAhluqCtc0BT4-uvg/"
    Tier1Tribe:
      channel: "Tier1Tribe"
      url: "https://www.youtube.com/channel/UChI2dxVFMXNU4rRrYtjO0Bg/"
    Task Force Spartan Milsim Media:
      channel: "Task Force Spartan Milsim Media"
      url: "https://www.youtube.com/channel/UCTubWp4vjzw47Dt02WllbPA/videos"
    The Tech Prepper:
      channel: "The Tech Prepper"
      url: "https://www.youtube.com/c/TheTechPrepper"
    Irish:
      channel: "Irish"
      url: "https://www.youtube.com/channel/UC-5bkh-OS6aKSyUIPmu5-DA"
    One 7 Six:
      channel: "One 7 Six"
      url: "https://www.youtube.com/channel/UCOXveiLfpYvjZ3V1zojaUbQ"
    Vernon Griffith II:
      channel: "Vernon Griffith II"
      url: "https://www.youtube.com/c/VernonGriffithII/videos"
    Orion Training Group:
      channel: "Orion Training Group"
      url: "https://www.youtube.com/channel/UCjdvhj_WZVDuX2qMy3HcmtA/videos"
    Marauder Collective:
      channel: "Marauder Collective"
      url: "https://www.youtube.com/channel/UCLXgViT_8wgTWCw7C_M9rZA/videos"
    sat952v:
      channel: "sat952v"
      url: "https://www.youtube.com/c/sat952v"
    Death Grip:
      channel: "Death Grip"
      url: "https://www.youtube.com/channel/UC4f0KX3Qf9DHSLE8F13AgIw/videos"
    Blakewater0326:
      channel: "Blakewater0326"
      url: "https://www.youtube.com/c/Blakewater0326"
    Keelback Training:
      channel: "Keelback Training"
      url: "https://www.youtube.com/channel/UCDbDL9Kr4qtvuRo6PO7J-jQ/videos"
    JTAC training with RIFLE:
      channel: "JTAC training with RIFLE!"
      url: "https://www.youtube.com/channel/UCQvuofg0IfKZtmn8acDkESw/videos"
    Heavy Lift Gaming:
      channel: "Heavy Lift Gaming"
      url: "https://www.youtube.com/user/GoSteelersSB17/videos"
    ExtraordinaireThe:
      channel: "Extraordinaire"
      url: "https://www.youtube.com/user/ExtraordinaireThe/videos"
    Black Mountain Milsim:
      channel: "Black Mountain Milsim"
      url: "https://www.youtube.com/user/Samw1121/videos"
    ROKSEAL:
      channel: "ROKSEAL"
      url: "https://www.youtube.com/c/ROKSEAL/videos"
    Ripperkon:
      channel: "Ripperkon"
      url: "https://www.youtube.com/user/ripperkon/videos"
    PrepairedAirman:
      channel: "Prepaired Airman"
      url: "https://www.youtube.com/c/PreparedAirman/videos"