import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum EnumCaseDetectionMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    declaration.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .map { $0.elements.first!.name }
      .map { ($0, $0.initialUppercased) }
      .map { original, uppercased in
        """
        var is\(raw: uppercased): Bool {
          if case .\(raw: original) = self {
            return true
          }
          return false
        }
        """
      }
  }
}

public enum EnumTitleMacro: MemberMacro{
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let dec = declaration as? EnumDeclSyntax else{throw EnumInitError.onlyApplicableToEnum}
        
        let members = dec.memberBlock.members
        let caseDec = members.compactMap({$0.decl.as(EnumCaseDeclSyntax.self)})
        let cases = caseDec.compactMap({$0.elements.first?.name})
        
        var title = """
        var title: String{
            switch self{
        """
        cases.forEach{titleCase in
            title += "case .\(titleCase):"
            title += "return \"\(titleCase.initialUppercased)\""
        }
        title += """
            }
        }
        """
        print("generated result is=======", DeclSyntax(stringLiteral: title))
        return [DeclSyntax(stringLiteral: title)]
    }
}

enum EnumInitError: CustomStringConvertible, Error{
    case onlyApplicableToEnum
    
    var description: String{
        switch self{
        case .onlyApplicableToEnum:
            return "@EnumTitle can be applied to an enum only"
        }
    }
}

extension TokenSyntax {
  fileprivate var initialUppercased: String {
    let name = self.text
    guard let initial = name.first else {
      return name
    }

    return "\(initial.uppercased())\(name.dropFirst())"
  }
}

@main
struct EnumMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumTitleMacro.self,
        EnumCaseDetectionMacro.self,
    ]
}
