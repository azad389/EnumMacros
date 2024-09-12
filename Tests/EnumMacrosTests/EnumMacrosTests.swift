import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnumMacrosMacros)
import EnumMacrosMacros

let testMacros: [String: Macro.Type] = [
    "EnumTitle": EnumTitleMacro.self,
    "EnumLocalizedTitle": EnumLocalizedTitleMacro.self,
    "CaseDetection": EnumCaseDetectionMacro.self,
    "EnumSpacedTitle": EnumSpacedTitleMacro.self,
    "EnumSpacedTitleLocalized": EnumSpacedTitleLocalizedMacro.self,
]
#endif

final class EnumMacrosTests: XCTestCase {
    func testEnumTitleMacro() {
        assertMacroExpansion("""
        @EnumTitle
        enum Gender {
           case male
           case female
        }
        """ , expandedSource: """
        
        enum Gender {
           case male
           case female

            var title: String {
                switch self {
                case .male:
                    return "Male"
                case .female:
                    return "Female"
                }
            }
        }
        """ , macros:testMacros)
    }
    
    func testEnumSpacedTitleMacro() {
        assertMacroExpansion("""
        @EnumSpacedTitle
        enum Gender {
           case genderMale
           case genderFemale
        }
        """ , expandedSource: """
        
        enum Gender {
           case genderMale
           case genderFemale

            var title: String {
                switch self {
                case .genderMale:
                    return "Gender Male"
                case .genderFemale:
                    return "Gender Female"
                }
            }
        }
        """ , macros:testMacros)
    }
    
    func testEmumCaseDetectionMacro(){
      assertMacroExpansion("""
      @CaseDetection
      enum Gender {
         case male
         case female
      }
      """, expandedSource:"""
      enum Gender {
         case male
         case female

          var isMale: Bool {
            if case .male = self {
              return true
            }
            return false
          }

          var isFemale: Bool {
            if case .female = self {
              return true
            }
            return false
          }
      }
      """, macros:testMacros)
    }
}
