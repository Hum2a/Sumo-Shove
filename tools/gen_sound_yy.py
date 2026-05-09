import json
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOUNDS = os.path.join(ROOT, "sounds")
NAMES = [
    "snd_sumo_ui_confirm",
    "snd_sumo_pause",
    "snd_sumo_tick",
    "snd_sumo_round_start",
    "snd_sumo_shove_hit",
    "snd_sumo_fall",
    "snd_sumo_round_win",
    "snd_sumo_double_ko",
]

# Must match field order expected by GameMaker GMSound v2 reader (sampleRate before soundFile).
SAMPLE_RATE = 44100

for name in NAMES:
    data = {
        "$GMSound": "v2",
        "%Name": name,
        "audioGroupId": {
            "name": "audiogroup_default",
            "path": "audiogroups/audiogroup_default.yy",
        },
        "bitDepth": 1,
        "channelFormat": 0,
        "compression": 0,
        "compressionQuality": 4,
        "conversionMode": 0,
        "duration": 0.12,
        "exportDir": "",
        "name": name,
        "parent": {"name": "Sumo Shove", "path": "Sumo Shove.yyp"},
        "preload": False,
        "resourceType": "GMSound",
        "resourceVersion": "2.0",
        "sampleRate": SAMPLE_RATE,
        "soundFile": name + ".wav",
        "tags": [],
        "volume": 1.0,
    }
    path = os.path.join(SOUNDS, name, name + ".yy")
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
    print("wrote", path)
