# WindUI Config System - Simplified Usage

## Perubahan Utama

Sistem config sekarang **otomatis mendeteksi dan menyimpan semua elemen UI** tanpa perlu registrasi manual.

## Sebelum (Manual Registration)

```lua
-- ❌ Cara lama - harus register semua elemen satu per satu
configFile:Register("ToggleAutoPlant", ToggleAutoPlant)
configFile:Register("DropdownPlants", DropdownPlants)
configFile:Register("DropdownRarities", DropdownRarities)
-- ... dan seterusnya untuk setiap elemen
configFile:Save()
```

## Sesudah (Automatic Detection)

```lua
-- ✅ Cara baru - otomatis mendeteksi semua elemen
local configFile = ConfigManager:CreateConfig("myconfig")
configFile:Save()  -- Semua elemen UI otomatis tersimpan!
```

## Contoh Lengkap

```lua
local WindUI = require("./src/init")

local Window = WindUI:CreateWindow({
    Title = "My App",
    Folder = "MyApp",
})

-- Buat elemen UI seperti biasa
local Tab = Window:Tab({ Title = "Main" })

Tab:Toggle({
    Title = "Auto Farm",
    Value = false,
})

Tab:Dropdown({
    Title = "Select Item",
    Values = {"Item1", "Item2"},
    Multi = true,
})

-- Setup config manager
local ConfigManager = Window.ConfigManager
ConfigManager:Init(Window)

-- Save config - otomatis menyimpan semua elemen!
local configFile = ConfigManager:CreateConfig("default")
configFile:Save()

-- Load config - otomatis memuat semua elemen!
configFile:Load()
```

## Cara Kerja Auto-Register

Sistem baru akan:
1. Otomatis mendeteksi semua elemen dari `Window.AllElements`
2. Menyimpan state setiap elemen (value, selected items, dll)
3. Memuat kembali state saat load config
4. Mencocokkan elemen berdasarkan Title dan Type

## Fitur Tambahan

### Custom Data
Anda masih bisa menyimpan data custom:

```lua
configFile:Set("lastSave", os.date())
configFile:Set("customData", { foo = "bar" })
configFile:Save()

-- Load
local customData = configFile:Get("customData")
```

### Manual Registration (Opsional)
Jika ingin kontrol lebih, masih bisa register manual:

```lua
local MyToggle = Tab:Toggle({ Title = "Special" })

local configFile = ConfigManager:CreateConfig("myconfig")
configFile:Register("MySpecialToggle", MyToggle)
configFile:Save()
```

### Disable Auto-Register
```lua
configFile.AutoRegisterEnabled = false
```

## Lihat Contoh

- `example_simplified.lua` - Contoh sederhana dengan auto-register
- `Example.lua` - Contoh kompleks dengan manual register (cara lama)

## Catatan

- Config version diupdate ke `1.2`
- Backward compatible dengan config lama
- Semua elemen dengan `__type` akan otomatis terdeteksi
- Element matching berdasarkan Title dan Type
