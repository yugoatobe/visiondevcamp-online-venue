# Tetra

An innovative online communication tool using Persona.

## ディレクトリ構成
<pre>
Tetra/
├── README.md
├── Tetra/
│   ├── TetraApp.swift
│   ├── Views
│   ├── Models
│   ├── Function
│   ├── Service
│   ├── Struct
│   ├── SwiftData
│   ├── GroupActivity
│   └── Resources
├── ImmersiveSpace
├── Utilities
├── Products
├── Configuration
└── LICENSE
</pre>

## 主なディレクトリの説明

- **Views/**  
  UIコンポーネントや、画面の実装をしている。

- **TetraApp.swift**  
  このアプリのエントリーポイント。

- **Models/**  
  実際のところ利用しているのはappState.swiftとPersonaCamera.swiftのみ。

- **Function/**  
  appStateで利用される関数を切り分けている。

- **Service/**  
  定数を定義する。

- **Struct/**  
  Nostrから取得するデータの型定義

- **SwiftData/**  
  SwiftDataに保存するデータであるリレーと自分自身のデータのスキーマを定義している。

- **GroupActivity/**  
  グループアクティビティに関するリソースを保管している。

- **ImmersiveSpace/**  
  現在利用してない（はず）
