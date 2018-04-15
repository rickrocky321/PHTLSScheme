//
//  File.swift
//  PHTLSScheme
//
//  Created by Tilon on 21/03/2018.
//  Copyright © 2018 Tilon. All rights reserved.
//

import Foundation

struct SchemeLibrary{
    
    // The PHTLS Scheme seperated into different platous and in each one the steps are arrenged.
    private let library = [
        ["S-Saftey", "A-Airway", "B-Breathing", "C-Circulation", "D-Disability", "E-Enviornment"],
        
        ["ביטחון המטפל והמטופל", "התרשמות מזירת האירוע ומנגנון הפציעה", "עצירת דימום פורץ", "דיווח ראשוני",
         "בדיקת הכרה ראשונית", "הסרת קסדה", "התרשמות מדרכי האוויר של הנפגע",
         "סילוק הפרשות במידת הצורך", "פתיחת נתיב אוויר", "חשיפת בית החזה", "בדיקה נשימתית כמותית (30 שניות)", "הנשמה",
         "חיפוש אחר דימומים במקומות נסתרים ועצירתם מיידית", "התבוננות על הבטן והאגן", "בדיקת דופק רדיאלי", "התרשמות מסימני הלם נלווים",
         "החלטה על החייאת נוזלים מאוזנת", "בדיקת הכרה חוזרת", "בפצוע מחוסר הכרה - בדיקת אישונים",
         "בפצוע בהכרה - בדיקת תנועות ידיים ורגליים", "השלמת הפשטה מלאה ועצירת דימום מיד עם מציאתו",
         "השכבה על האלונקה, כיסוי והגנה מהסביבה", "הכנה לפינוי", "דיווח סופי - דגש על דחיפות פינוי"],
        
        ["קבלת דיווח", "בחינה ויזואלית", "סיפור מקרה", "התבוננות", "קולו של הנפגע",
         "פתיחת פה- בדיקת הפרשות/סימני כוויות/שאיפת עשן בלוע",
         "בדיקת צווארו של הפצוע-סימני חבלה, המטומה מתפשטת", "אם הפצוע לא מגיב לכאב ביצוע jaw thrust והחדרת A.W",
         "התרשמות מחבלות או פציעות חודרות לבית החזה", "בדיקת איכות הנשימה והתפשטות דו-צדדית",
         "במידה וקצב הנשימה הוא מתחת ל-10 או מעל ל-30 לדקה או סטורציה נמוכה מ-90%",
         "בית-שחי, מפשעות, גפיים, ראש, צוואר, עכוז, וגב", "התרשמות מסימני חבלה",
         "כמותי ואיכותי (15 שניות)", "חיוורון, הזעה, טמפרטורת עור נמוכה, מילוי קפילארי מושהה",
         "במידה ויש הידרדרות במצב ההכרה, יש לחזור לשלב ה-A",
         "סימטריה, גודל (צרים, רחבים) ותגובה לאור", "תנועות פשוטות בהתאם לפקודה קולית", "קיבוע לקרש גב במקרה הצורך"]
        ]
    // The sequence in which to read from the PHTLS Scheme library
    private let sequence: [(Int, Int)] = [
        (0, 1), (1, 2), (2, 3), (1, 2), // S
        (0, 1), (1, 3), (2, 4), (1, 2), (2, 1), // A
        (0, 1), (1, 1), (2, 2), (1, 2), (2, 1), // B
        (0, 1), (1, 1), (2, 1), (1, 1), (2, 1), (1, 1), (2, 1), (1, 1), (2, 1), (1, 1), // C
        (0, 1), (1, 1), (2, 1), (1, 1), (2, 1), (1, 1), (2, 1), // D
        (0, 1), (1, 2), (2, 1), (1, 2) // E
        ]
    
    init() {
        let SchemeFormed = SchemeJsonParser()
    }
    
    var currentStepString: String { return library[currentPlatous][currentStepInLibrary[currentPlatous]] }
    private(set) var lastStepString = ["", "", ""]
    private(set) var currentStepInLibrary = [0, 0, 0]
    private var currentStep = 0  // The current step in the specific sequence
    var currentPlatous: Int { return sequence[indexInSequence].0 }
    var numOfStepsInCurrentSequence: Int { return sequence[indexInSequence].1 }
    private var indexInSequence = 0
    private(set) var isFinished = false
    
    mutating func nextStep() {
        lastStepString[currentPlatous] = currentStepString
        currentStep += 1
        // Either way you should increase the current step in the library at the right platous
        currentStepInLibrary[currentPlatous] += 1
        // Check if finished this specific sequence
        if currentStep == numOfStepsInCurrentSequence {
            indexInSequence += 1
            currentStep = 0
            // Check if finished the whole sequence
            if indexInSequence == sequence.count { isFinished = true }
        }
        // if Options are generated and SchemeLibrary is finished then there will be an "Out Of Bounds" exception
        if !isFinished { generateOptions() }
    }
    
    var numOfOptions = 4 // Default is 4
    lazy private(set) var currentCorrectOption = numOfOptions.arc4random
    private(set) var currentOptions = [String]()
    private var randomStepInCurrentPlatous: Int { return library[currentPlatous].count.arc4random }
    
    mutating func generateOptions() {
        currentOptions = Array(repeating: currentStepString, count: numOfOptions)
        currentCorrectOption = numOfOptions.arc4random
        for index in 0..<numOfOptions {
            if index != currentCorrectOption {
                // While loop so that it won't add multiplicities, and the currentCorrectOption twice
                var randomPosition = randomStepInCurrentPlatous
                while currentOptions.contains(library[currentPlatous][randomPosition]) || randomPosition == currentCorrectOption {
                    randomPosition = randomStepInCurrentPlatous
                }
                currentOptions[index] = library[currentPlatous][randomPosition]
                print(currentOptions)
            }
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}
