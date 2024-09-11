// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: named(title))
public macro EnumTitle() = #externalMacro(module: "EnumMacrosMacros", type: "EnumTitleMacro")


@attached(member, names: arbitrary)
public macro CaseDetection() = #externalMacro(module: "EnumMacrosMacros", type: "EnumCaseDetectionMacro")
