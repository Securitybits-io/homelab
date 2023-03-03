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
  folder: "YouTube"
  channels:
    Allan Su:
      channel: "Allan-Su"
      url: "https://www.youtube.com/c/AllanSu/videos"
    Chris Hau:
      channel: "Chris-Hau"
      url: "https://www.youtube.com/c/ChrisHau/videos"
    Lizzie Peirce:
      channel: "Lizzie-Peirce"
      url: "https://www.youtube.com/c/LizziePeirce/videos"
    Becki and Chris:
      channel: "Becki and Chris"
      url: "https://www.youtube.com/c/BeckiandChris/videos"
    Dani Connor:
      channel: "Dani Connor"
      url: "https://www.youtube.com/c/DaniConnorWild/videos"
    Peter Mckinnon:
      channel: "Peter-McKinnon"
      url: "https://www.youtube.com/c/PeterMcKinnon/videos"
    OpticalWander:
      channel: "OpticalWander"
      url: "https://www.youtube.com/c/SamuelBassett/videos"
    PierreTLambert:
      channel: "Pierre T. Lambert"
      url: "https://www.youtube.com/c/PierreTLambert101/videos"
    Sam Newton:
      channel: "Sam Newton"
      url: "https://www.youtube.com/c/SamNewton/videos"
    Hayden Pedersen:
      channel: "Hayden Pedersen"
      url: "https://www.youtube.com/c/HaydenPedersen/videos"
    North Borders:
      channel: "North Borders"
      url: "https://www.youtube.com/c/NorthBorders/videos"
    Julia Trotti:
      channel: "Julia Trotti"
      url: "https://www.youtube.com/c/DigitalFilmLabs/videos"
    Mark Denney:
      channel: "Mark Denney"
      url: "https://www.youtube.com/c/MarkDenneyPhoto/videos"
    Thomas Heaton:
      channel: "Thomas Heaton"
      url: "https://www.youtube.com/c/ThomasHeatonPhoto/videos"
    Harry Shaw:
      channel: "Harry Shaw"
      url: "https://www.youtube.com/channel/UC2hKnO4ySZJbfZgim7pIY0g/videos"
    Sean Tucker:
      channel: "Sean tucker"
      url: "https://www.youtube.com/c/SeanTuckerphoto/videos"
    ippsec:
      channel: "Ippsec"
      url: "https://www.youtube.com/c/ippsec"
    Rook:
      channel: "Rook"
      url: "https://www.youtube.com/c/DerekRook"
    LiveOverflow:
      channel: "liveoverflow"
      url: "https://www.youtube.com/channel/UClcE-kVhqyiHCcjYwcpfj9w"
    StackSmashing:
      channel: "StackSmashing"
      url: "https://www.youtube.com/c/stacksmashing"
    DUST:
      channel: "DUST"
      url: "https://www.youtube.com/c/watchdust"
    EvanRoyalty:
      channel: "EvanRoyalty"
      url: "https://www.youtube.com/c/EvanRoyalty/videos"
    HackInTheBox:
      channel: "HackInTheBox"
      url: "https://www.youtube.com/user/hitbsecconf/videos"
    OffensiveCon:
      channel: "OffensiveCon"
      url: "https://www.youtube.com/c/OffensiveCon/videos"
    BosnianBill:
      channel: "BosnianBill"
      url: "https://www.youtube.com/c/bosnianbill/videos"
    LockPickingLawyer:
      channel: "LockPickingLawyer"
      url: "https://www.youtube.com/c/lockpickinglawyer/videos"
    BPSSpace:
      channel: "BPS.Space"
      url: "https://www.youtube.com/c/BPSspace/videos"
    TechWorldWithNana:
      channel: "TechWorld with Nana"
      url: "https://www.youtube.com/c/TechWorldwithNana/videos"
    IBMTechnology:
      channel: "IBM Technology"
      url: "https://www.youtube.com/c/IBMTechnology/videos"
    HashiCorp:
      channel: "HashiCorp"
      url: "https://www.youtube.com/c/HashiCorp/videos"
    MakeMeHack:
      channel: "Make Me Hack"
      url: "https://www.youtube.com/c/MakeMeHack/videos"
    AlexisOutdoors:
      channel: "Alexis Outdoors"
      url: "https://www.youtube.com/@AlexisOutdoors"