import Foundation

class userAddressClassModel {
    
    fileprivate var _ID: Int?
    fileprivate var _user_id: Int?
    fileprivate var _title: String?
    fileprivate var _line1: String?
    fileprivate var _line2: String?
    fileprivate var _line3: String?
    //private var _postcode: String?
    fileprivate var _city: String?
    fileprivate var _country: String?
    fileprivate var _geolon: Double?
    fileprivate var _geolat: Double?
    fileprivate var _notes: String?
    
    init () {
        _title = ""
        _line1 = ""
        _line2 = ""
        _line3 = ""
       // _postcode = ""
        _city = ""
        _country = ""
        _notes = ""
        _geolat = 0.0
        _geolon = 0.0
    }
    
    func getID()-> Int {
        return _ID!
    }
    
    func getuserid()-> Int {
        return _user_id!
    }
    
    func gettitle()-> String {
        return _title!
    }
    
    func getline1()-> String {
        return _line1!
    }
    
    func getline2()-> String {
        return _line2!
    }
    
    func getline3()-> String {
        return _line3!
    }
    
//    func getpostcode()-> String {
//        return _postcode!
//    }
    
    func getcity()-> String {
        return _city!
    }
    
    func getcountry()-> String {
        return _country!
    }
    
    func getgeolon()-> Double {
        return _geolon!
    }
    
    func getgeolat()-> Double {
        return _geolat!
    }
    
    func getnotes()-> String {
        return _notes!
    }
    
    func setID(_ id: Int) {
        _ID = id
    }
    
    func setuserid(_ userid: Int) {
        _user_id = userid
    }
    
    func settitle(_ title: String) {
        _title = title
    }
    
    func setline1(_ line1: String) {
        _line1 = line1
    }
    
    func setline2(_ line2: String) {
        _line2 = line2
    }
    
    func setline3(_ line3: String) {
        _line3 = line3
    }
    
//    func setpostcode(postcode: String) {
//        _postcode = postcode
//    }
    
    func setcity(_ city: String) {
        _city = city
    }
    
    func setcountry(_ country: String) {
        _country = country
    }
    
    func setgeolon(_ geolon: Double) {
        _geolon = geolon
    }
    
    func setgeolat(_ geolat: Double) {
        _geolat = geolat
    }
    
    func setnotes(_ notes: String) {
        _notes = notes
    }
    
}
