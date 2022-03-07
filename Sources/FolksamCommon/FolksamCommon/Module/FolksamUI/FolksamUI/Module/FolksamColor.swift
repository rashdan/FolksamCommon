#if !os(macOS)
import UIKit

public enum FolksamColor {
    /*
     white: '#ffffff',
     blue1: '#0A4682',
     blue2: '#007BCF',
     blue3: '#009CE0',
     blue4: '#7DC8F0',
     blue5: '#C8E6FA',
     blue6: '#E2F2FC',
     gray1: '#333333',
     gray2: '#666666',
     gray3: '#767676',
     gray4: '#aaaaaa',
     gray5: '#cecece',
     gray6: '#eeeeee',
     green1: '#B0CB0B',
     green2: '#D2E182',
     green3: '#F5F7DE',
     offWhite1: '#F5FCFF',
     beige1: '#E5E5E5',
     beige2: '#F8F6F1',
     pink1: '#E6007E',
     black1: '#000000',
     red1: '#FF0000',
     red2: '#F0A5C3',
     purple1: '#951062',
     yellow1: '#E7B13D'

     --blue1: #0a4682;
     --blue2m: #0093de;
     --blue2: #009fe4;
     --blue2l: #00aae6;
     --blue3: #7dc8f0;
     --blue4: #c8e6fa;
     */

    public static let Background1 = UIColor(requiredNamed: "FolksamColors/background1")

    public static let beige3 = UIColor(requiredNamed: "FolksamColors/beige3")
    public static let Blue1 = UIColor(requiredNamed: "FolksamColors/Blue1")
    public static let Blue2m = UIColor(requiredNamed: "FolksamColors/Blue2m")
    public static let Blue2 = UIColor(requiredNamed: "FolksamColors/Blue2")
    public static let Blue3 = UIColor(requiredNamed: "FolksamColors/Blue3")
    public static let Blue4 = UIColor(requiredNamed: "FolksamColors/Blue4")
    public static let Blue21 = UIColor(requiredNamed: "FolksamColors/Blue21")
    public static let Green1 = UIColor(requiredNamed: "FolksamColors/green1")
    public static let Green2 = UIColor(requiredNamed: "FolksamColors/green2")
    public static let Green3 = UIColor(requiredNamed: "FolksamColors/green3")

    public static let Gray1 = UIColor(requiredNamed: "FolksamColors/gray1")
    public static let Gray2 = UIColor(requiredNamed: "FolksamColors/gray2")
    public static let Gray3 = UIColor(requiredNamed: "FolksamColors/gray3")
    public static let Gray4 = UIColor(requiredNamed: "FolksamColors/gray4")
    public static let Gray5 = UIColor(requiredNamed: "FolksamColors/gray5")
    public static let Gray6 = UIColor(requiredNamed: "FolksamColors/gray6")
}

extension UIColor {
    convenience init(requiredNamed imageName: String) {
        self.init(named: imageName, in: Bundle.module, compatibleWith: nil)!
        //Bundle(identifier: "com.folksam.folksamapp.folksamCommon")
    }
}
#endif
