// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(title))
public macro EnumTitle() = #externalMacro(module: "EnumMacrosMacros", type: "EnumTitleMacro")

@attached(member, names: named(title))
public macro EnumLocalizedTitle() = #externalMacro(module: "EnumMacrosMacros", type: "EnumLocalizedTitleMacro")


@attached(member, names: arbitrary)
public macro CaseDetection() = #externalMacro(module: "EnumMacrosMacros", type: "EnumCaseDetectionMacro")

@attached(member, names: arbitrary)
public macro EnumSpacedTitle() = #externalMacro(module: "EnumMacrosMacros", type: "EnumSpacedTitleMacro")

@attached(member, names: arbitrary)
public macro EnumSpacedTitleLocalized() = #externalMacro(module: "EnumMacrosMacros", type: "EnumSpacedTitleLocalizedMacro")


