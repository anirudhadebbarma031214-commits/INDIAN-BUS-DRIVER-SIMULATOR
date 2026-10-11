# INDIAN BUS DRIVER SIMULATOR

**A game by ANI STUDIO**

Mobile bus-driving project inspired by Agartala, Tripura. The repository retains the original Roblox/Luau prototype and now includes an early **standalone Godot Android port** under `android-godot/`.

## Download the Android APK

1. Open the [GitHub Actions APK build workflow](https://github.com/anirudhadebbarma031214-commits/INDIAN-BUS-DRIVER-SIMULATOR/actions/workflows/android-apk.yml).
2. Select **Run workflow** and run it on the `main` branch (or wait for a push that changes the Godot project).
3. Open the newest completed run. If it is green, scroll to **Artifacts** and download `IndianBusDriverSimulator-Android-APK`.
4. Extract the ZIP artifact to get `IndianBusDriverSimulator.apk`, then transfer it to your Android phone and install it. Android may ask you to allow installation from that source.

**If the workflow fails, there is no APK artifact yet.** Open the failed run and check the first red step; the project has not been verified by a successful CI build until the workflow is green.

## Standalone Android version

The `android-godot/` folder contains a Godot 4.3 project with:
- A procedural, simplified Agartala-inspired 3D scene with roads, market shops, homes, trees, a palace-inspired landmark, railway station, airport, and Udaipur destination marker.
- A bus model and a follow camera.
- Route selector, speed/fuel HUD, touchscreen steering and throttle buttons, and keyboard controls for desktop testing.
- Android export preset targeting arm64.

This is a **port/reimplementation**, not an automatic conversion of Roblox Luau code. The Android version is an early prototype using simple generated 3D shapes, not a realistic finished simulator. It has not yet been tested on a real Android phone or confirmed to export successfully.

## Build locally

Install [Godot 4.3](https://godotengine.org/download/) with Android export templates and Android export dependencies. Open `android-godot/project.godot`, then export using the **Android** preset. You can also run the scene in Godot on desktop to inspect the prototype.

## Original Roblox prototype

The Roblox source files remain in:
- [3D Agartala map script](https://github.com/anirudhadebbarma031214-commits/INDIAN-BUS-DRIVER-SIMULATOR/blob/main/src/server/AgartalaMap.server.lua)
- [Bus driving script](https://github.com/anirudhadebbarma031214-commits/INDIAN-BUS-DRIVER-SIMULATOR/blob/main/src/server/BusDriving.server.lua)
- [Mobile driving controls](https://github.com/anirudhadebbarma031214-commits/INDIAN-BUS-DRIVER-SIMULATOR/blob/main/src/client/BusControls.client.lua)

The generated city layout is inspired by Agartala and is not a surveyed 1:1 recreation.

## Project downloads

- [Download the full source ZIP](https://github.com/anirudhadebbarma031214-commits/INDIAN-BUS-DRIVER-SIMULATOR/archive/refs/heads/main.zip)
- [Open GitHub Actions](https://github.com/anirudhadebbarma031214-commits/INDIAN-BUS-DRIVER-SIMULATOR/actions)
- [Open repository](https://github.com/anirudhadebbarma031214-commits/INDIAN-BUS-DRIVER-SIMULATOR)

Created by **ANI STUDIO**.
