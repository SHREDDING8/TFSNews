//
//  StringExtension.swift
//  TFSNews
//
//  Created by SHREDDING on 05.02.2023.
//

import Foundation

extension String{
    func localize(tableName:String = "Localizable") -> String{
        return NSLocalizedString(self, tableName: tableName, bundle: .main, value: "нет перевода", comment: "")
    }
}
