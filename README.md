# twrp device tree for motorola edge 50 ultra (ctwo)

## device specification

| basic | specification |
| --- | --- |
| model | XT2401-1 |
| chipset | Snapdragon 8s Gen 3 (SM8635) |
| GPU | Adreno 735 |
| memory | 12/16 GB RAM |
| storage | 512/1024 GB |
| battery | 4,500 mAh |
| dimensions and weight | 161 × 72.4 × 8.59 mm; 197 g |
| display | 6.7-inch pOLED, 1220 × 2712, 144 Hz |
| cameras | rear 50 MP + 50 MP + 64 MP; front 50 MP |

## what's working
Initial builds yet.
- ADBD
- Touchscreen (goodix)

## what's not working
N/A

## How to build?
- export ALLOW_MISSING_DEPENDENCIES=true
- source build/envsetup.sh 
- lunch twrp_ctwo-eng 
- m recoveryimage -j$(nproc)
