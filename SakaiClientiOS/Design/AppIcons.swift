//
//  AppIcons.swift
//  SakaiClientiOS
//
//  Created by Pranay Neelagiri on 1/3/19.
//

import Foundation

final class AppIcons {
    /*
     013 African Languages and Literatures
     014 Africana Studies
     016 African Area Studies
     018 Aging
     050 American Studies
     070 Anthropology
     078 Armenian
     080 Art, Visual
     081 Art
     082 Art History
     090 Arts and Science (college courses)
     098 Asian Studies
     105 Astrophysics
     115 Biochemistry
     119 Biological Sciences
     145 Catalan
     146 Cell Biology and Neuroscience
     160 Chemistry
     165 Chinese
     175 Cinema Studies
     185 Cognitive Science
     190 Classics
     195 Comparative Literature
     198 Computer Science
     202 Criminal Justice
     203 Dance
     206 Dance
     214 East Asian Languages and Area Studies
     220 Economics
     300 Education
     350 English
     351 English: Topics
     353 English: Literary Theory
     354 English: Film Studies
     355 English: Composition and Writing
     360 European Studies
     377 Exercise Science and Sport Studies
     420 French
     447 Genetics
     450 Geography
     460 Geological Sciences
     470 German
     489 Greek, Modern
     490 Greek, Ancient
     505 Hindi
     506 History: General/Comparative
     508 History: African, Asian, and Latin American
     510 History: European
     512 History: American
     513 History/French
     514 History/Political Science
     535 Hungarian
     556 Interdisciplinary Studies, FAS
     560 Italian
     563 Jewish Studies
     565 Japanese
     567 Journalism and Media Studies
     574 Korean
     575 Labor Studies
     578 Labor Studies and Employment Relations
     580 Latin
     590 Latin American Studies
     615 Linguistics
     628 Marine Sciences
     640 Mathematics
     660 Medical Technology
     667 Medieval Studies
     685 Middle Eastern Studies
     690 Military Education, Air Force
     691 Military Education, Army
     694 Molecular Biology and Biochemistry
     700 Music
     701 Music, Applied
     711 Operations Research
     730 Philosophy
     750 Physics
     787 Polish
     790 Political Science
     810 Portuguese
     830 Psychology
     836 Puerto Rican and Hispanic Caribbean Studies
     840 Religion
     860 Russian
     910 Social Work
     920 Sociology
     925 South Asian Studies
     940 Spanish
     959 Study Abroad
     960 Statistics
     965 Theater Arts
     966 Theater Arts
     967 Ukrainian
     988 Women's and Gender Studies
     */

    static let codeToIcon: [Int: String] = {
        var codeToIcon: [Int: String] = [:]

        if let filepath = Bundle.main.path(forResource: "test", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: filepath)
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let iconConfig = try decoder.decode(IconConfiguration.self, from: data)
                for icon in iconConfig.icons {
                    guard let unicodeInt = Int(icon.iconInt, radix: 16),
                        let scalar = UnicodeScalar(unicodeInt) else {
                        continue
                    }
                    let character = Character(scalar)
                    codeToIcon.updateValue(String(character), forKey: icon.subjectCode)
                }
            } catch {
                print("content could not be loaded")
            }
        } else {
            print("test.json not found")
        }
        return codeToIcon
    }()
}
