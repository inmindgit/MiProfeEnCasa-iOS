//
//  Models.swift
//  MiProfeEnCasa
//
//  Created by Juan Arrillaga on 5/2/19.
//  Copyright © 2019 Juan Arrillaga. All rights reserved.
//

import Foundation
import ObjectMapper

protocol Meta {
    static func url() -> String
    static func queryString() -> String
    static func expand() -> String
}

@objc(LoginModel)
class LoginModel : NSObject, Mappable, Meta, NSCoding
{
    var result: UserModel?
    var code: Int?
    var error_message: String?
    
    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        code <- map["code"]
        error_message <- map["error_message"]
    }
    
    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return "usuario/login"
    }
    
    static func expand() -> String{
        return ""
    }
    
    required init(coder aDecoder: NSCoder) {
        if let result = aDecoder.decodeObject(forKey: "result") as? UserModel? {
            self.result = result
        }
        
        if let code = aDecoder.decodeObject(forKey: "code") as? Int {
            self.code = code
        }
        
        if let error_message = aDecoder.decodeObject(forKey: "error_message") as? String {
            self.error_message = error_message
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(result, forKey: "result")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(error_message, forKey: "error_message")
    }
}


@objc(UserModel)
class UserModel : NSObject, Mappable, Meta, NSCoding
{
    var _id: Int?
    var tipoUsuarioId: Int?
    var franquiciaId: Int?
    var nombre: String?
    var apellido: String?
    var cedulaIdentidad: String?
    var direccionDepartamentoId: Int?
    var direccionCalle: String?
    var direccionNumero: String?
    var direccionApto: String?
    var direccionEsquina: String?
    var celular: String?
    var telefono: String?
    var email: String?
    var instituto: String?
    var carrera: String?
    var nivelEducativoId: String?
    var grado: String?
    var habilitado: Int?
    var nombreResponsable: String?
    var apellidoResponsable: String?
    var cedulaIdentidadResponsable: String?
    var emailResponsable: String?
    var celularResponsable: String?
    var referenciaEmpresa: String?
    var eliminado: Int?
    var skypeId: String?
    var ultimoLogin: String?
    var guid: String?
    var TUdescripcion: String?
    var FpaisId: String?
    var Fnombre: String?
    var PFnombre: String?
    var DpaisId: String?
    var Dnombre: String?
    var PDnombre: String?
    var NEnombre: String?

    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        tipoUsuarioId <- map["tipoUsuarioId"]
        franquiciaId <- map["franquiciaId"]
        nombre <- map["nombre"]
        apellido <- map["apellido"]
        cedulaIdentidad <- map["cedulaIdentidad"]
        direccionDepartamentoId <- map["direccionDepartamentoId"]
        direccionCalle <- map["direccionCalle"]
        direccionNumero <- map["direccionNumero"]
        direccionApto <- map["direccionApto"]
        direccionEsquina <- map["direccionEsquina"]
        celular <- map["celular"]
        telefono <- map["telefono"]
        email <- map["email"]
        instituto <- map["instituto"]
        carrera <- map["carrera"]
        nivelEducativoId <- map["nivelEducativoId"]
        grado <- map["grado"]
        habilitado <- map["habilitado"]
        nombreResponsable <- map["nombreResponsable"]
        apellidoResponsable <- map["apellidoResponsable"]
        cedulaIdentidadResponsable <- map["cedulaIdentidadResponsable"]
        emailResponsable <- map["emailResponsable"]
        celularResponsable <- map["celularResponsable"]
        referenciaEmpresa <- map["referenciaEmpresa"]
        eliminado <- map["eliminado"]
        skypeId <- map["skypeId"]
        ultimoLogin <- map["ultimoLogin"]
        guid <- map["guid"]
        TUdescripcion <- map["TUdescripcion"]
        FpaisId <- map["FpaisId"]
        Fnombre <- map["Fnombre"]
        PFnombre <- map["PFnombre"]
        DpaisId <- map["DpaisId"]
        Dnombre <- map["Dnombre"]
        PDnombre <- map["PDnombre"]
        NEnombre <- map["NEnombre"]
    }
    

    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return ""
    }
    
    static func expand() -> String{
        return ""
    }
    
    required init(coder aDecoder: NSCoder) {
        if let _id = aDecoder.decodeObject(forKey: "_id") as? Int? {
            self._id = _id
        }
        if let tipoUsuarioId = aDecoder.decodeObject(forKey: "tipoUsuarioId") as? Int {
            self.tipoUsuarioId = tipoUsuarioId
        }
        if let franquiciaId = aDecoder.decodeObject(forKey: "franquiciaId") as? Int {
            self.franquiciaId = franquiciaId
        }
        if let nombre = aDecoder.decodeObject(forKey: "nombre") as? String {
            self.nombre = nombre
        }
        
        if let apellido = aDecoder.decodeObject(forKey: "apellido") as? String {
            self.apellido = apellido
        }
        
        if let cedulaIdentidad = aDecoder.decodeObject(forKey: "cedulaIdentidad") as? String {
            self.cedulaIdentidad = cedulaIdentidad
        }
        
        if let direccionDepartamentoId = aDecoder.decodeObject(forKey: "direccionDepartamentoId") as? Int {
            self.direccionDepartamentoId = direccionDepartamentoId
        }
        
        if let direccionCalle = aDecoder.decodeObject(forKey: "direccionCalle") as? String {
            self.direccionCalle = direccionCalle
        }
        
        if let direccionNumero = aDecoder.decodeObject(forKey: "direccionNumero") as? String {
            self.direccionNumero = direccionNumero
        }
        
        if let direccionApto = aDecoder.decodeObject(forKey: "direccionApto") as? String {
            self.direccionApto = direccionApto
        }
        
        if let direccionEsquina = aDecoder.decodeObject(forKey: "direccionEsquina") as? String {
            self.direccionEsquina = direccionEsquina
        }
        
        if let celular = aDecoder.decodeObject(forKey: "celular") as? String? {
            self.celular = celular
        }
        
        if let telefono = aDecoder.decodeObject(forKey: "telefono") as? String? {
            self.telefono = telefono
        }
        
        if let email = aDecoder.decodeObject(forKey: "email") as? String? {
            self.email = email
        }
        
        if let instituto = aDecoder.decodeObject(forKey: "instituto") as? String {
            self.instituto = instituto
        }
        
        if let carrera = aDecoder.decodeObject(forKey: "carrera") as? String {
            self.carrera = carrera
        }
        
        if let nivelEducativoId = aDecoder.decodeObject(forKey: "nivelEducativoId") as? String {
            self.nivelEducativoId = nivelEducativoId
        }
        
        if let grado = aDecoder.decodeObject(forKey: "grado") as? String {
            self.grado = grado
        }
        
        if let habilitado = aDecoder.decodeObject(forKey: "habilitado") as? Int {
            self.habilitado = habilitado
        }
        
        if let nombreResponsable = aDecoder.decodeObject(forKey: "nombreResponsable") as? String {
            self.nombreResponsable = nombreResponsable
        }
        
        if let cedulaIdentidadResponsable = aDecoder.decodeObject(forKey: "cedulaIdentidadResponsable") as? String {
            self.cedulaIdentidadResponsable = cedulaIdentidadResponsable
        }
        
        if let emailResponsable = aDecoder.decodeObject(forKey: "emailResponsable") as? String {
            self.emailResponsable = emailResponsable
        }
        
        if let celularResponsable = aDecoder.decodeObject(forKey: "celularResponsable") as? String {
            self.celularResponsable = celularResponsable
        }
        
        if let referenciaEmpresa = aDecoder.decodeObject(forKey: "referenciaEmpresa") as? String {
            self.referenciaEmpresa = referenciaEmpresa
        }
        
        if let eliminado = aDecoder.decodeObject(forKey: "eliminado") as? Int {
            self.eliminado = eliminado
        }
        
        if let skypeId = aDecoder.decodeObject(forKey: "skypeId") as? String {
            self.skypeId = skypeId
        }
        
        if let ultimoLogin = aDecoder.decodeObject(forKey: "ultimoLogin") as? String {
            self.ultimoLogin = ultimoLogin
        }
        
        if let guid = aDecoder.decodeObject(forKey: "guid") as? String {
            self.guid = guid
        }
        
        if let TUdescripcion = aDecoder.decodeObject(forKey: "TUdescripcion") as? String {
            self.TUdescripcion = TUdescripcion
        }
        
        if let FpaisId = aDecoder.decodeObject(forKey: "FpaisId") as? String {
            self.FpaisId = FpaisId
        }
        
        if let Fnombre = aDecoder.decodeObject(forKey: "Fnombre") as? String {
            self.Fnombre = Fnombre
        }
        
        if let DpaisId = aDecoder.decodeObject(forKey: "DpaisId") as? String {
            self.DpaisId = DpaisId
        }
        
        if let Dnombre = aDecoder.decodeObject(forKey: "Dnombre") as? String {
            self.Dnombre = Dnombre
        }
        
        if let NEnombre = aDecoder.decodeObject(forKey: "NEnombres") as? String {
            self.NEnombre = NEnombre
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_id, forKey: "_id")
        aCoder.encode(tipoUsuarioId, forKey: "tipoUsuarioId")
        aCoder.encode(franquiciaId, forKey: "franquiciaId")
        aCoder.encode(nombre, forKey: "nombre")
        aCoder.encode(apellido, forKey: "apellido")
        aCoder.encode(cedulaIdentidad, forKey: "cedulaIdentidad")
        aCoder.encode(direccionDepartamentoId, forKey: "direccionDepartamentoId")
        aCoder.encode(direccionCalle, forKey: "direccionCalle")
        aCoder.encode(direccionNumero, forKey: "direccionNumero")
        aCoder.encode(direccionApto, forKey: "direccionApto")
        aCoder.encode(direccionEsquina, forKey: "direccionEsquina")
        aCoder.encode(celular, forKey: "celular")
        aCoder.encode(telefono, forKey: "telefono")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(instituto, forKey: "instituto")
        aCoder.encode(carrera, forKey: "carrera")
        aCoder.encode(nivelEducativoId, forKey: "nivelEducativoId")
        aCoder.encode(grado, forKey: "grado")
        aCoder.encode(habilitado, forKey: "habilitado")
        aCoder.encode(nombreResponsable, forKey: "nombreResponsable")
        aCoder.encode(apellidoResponsable, forKey: "apellidoResponsable")
        aCoder.encode(cedulaIdentidadResponsable, forKey: "cedulaIdentidadResponsable")
        aCoder.encode(emailResponsable, forKey: "emailResponsable")
        aCoder.encode(celularResponsable, forKey: "celularResponsable")
        aCoder.encode(referenciaEmpresa, forKey: "referenciaEmpresa")
        aCoder.encode(eliminado, forKey: "eliminado")
        aCoder.encode(skypeId, forKey: "skypeId")
        aCoder.encode(ultimoLogin, forKey: "ultimoLogin")
        aCoder.encode(guid, forKey: "guid")
        aCoder.encode(TUdescripcion, forKey: "TUdescripcion")
        aCoder.encode(FpaisId, forKey: "FpaisId")
        aCoder.encode(Fnombre, forKey: "Fnombre")
        aCoder.encode(DpaisId, forKey: "DpaisId")
        aCoder.encode(Dnombre, forKey: "Dnombre")
        aCoder.encode(PDnombre, forKey: "PDnombre")
        aCoder.encode(NEnombre, forKey: "NEnombre")
    }
}

@objc(RequestListModel)
class RequestListModel : NSObject, Mappable, Meta
{
    var result: [RequestModel]?
    var code: Int?
    var error_message: String?
    
    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        code <- map["code"]
        error_message <- map["error_message"]
    }
    
    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return "solicitud/maestro/listar/13/0"
    }
    
    static func expand() -> String{
        return ""
    }
}

@objc(RequestModel)
class RequestModel : NSObject, Mappable, Meta
{
    var _id: Int?
    var solicitudAlumnoId: Int?
    var cursoAsociadoId: Int?
    var maestroId: Int?
    var estadoSolicitudMaestroId: Int?
    var SAid: Int?
    var SAalumnoId: Int?
    var SAcursoId: Int?
    var SAprueba: String?
    var SAfechaPrueba: String?
    var SAfechaInicio: String?
    var SAvecesPorSemana: Int?
    var SAfecha: String?
    var SAobservaciones: String?
    var SAestadoSolicitudAlumno: Int?
    var SAnoPresencial: Int?
    var Uid: Int?
    var UtipoUsuarioId: Int?
    var UfranquiciaId: Int?
    var Unombre: String?
    var Uapellido: String?
    var UcedulaIdentidad: String?
    var UdireccionCalle: String?
    var UdireccionNumero: String?
    var UdireccionApto: String?
    var UdireccionEsquina: String?
    var Ucelular: String?
    var Utelefono: String?
    var Uemail: String?
    var Uinstituto: String?
    var Ucarrera: String?
    var UnivelEducativoId: String?
    var Ugrado: String?
    var Uavatar: String?
    var UskypeId: String?
    var Cid: Int?
    var Cnombre: String?
    var Cdescripcion: String?
    var CmateriaId: Int?
    var CfranquiciaId: Int?
    var CtipoCuponeraAsociadaId: Int?
    var Iid: Int?
    var UMid: Int?
    var UMfranquiciaId: Int?
    var UMnombre: String?
    var ClSMId: Int?
    var UMapellido: String?
    var horarios: [ScheduleModel]?
    var claseId: Int?
    
    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        solicitudAlumnoId <- map["solicitudAlumnoId"]
        cursoAsociadoId <- map["cursoAsociadoId"]
        maestroId <- map["maestroId"]
        estadoSolicitudMaestroId <- map["estadoSolicitudMaestroId"]
        SAid <- map["SAid"]
        SAalumnoId <- map["SAalumnoId"]
        SAcursoId <- map["SAcursoId"]
        SAprueba <- map["SAprueba"]
        SAfechaPrueba <- map["SAfechaPrueba"]
        SAfechaInicio <- map["SAfechaInicio"]
        SAvecesPorSemana <- map["SAvecesPorSemana"]
        SAfecha <- map["SAfecha"]
        SAobservaciones <- map["SAobservaciones"]
        SAestadoSolicitudAlumno <- map["SAestadoSolicitudAlumno"]
        SAnoPresencial <- map["SAnoPresencial"]
        Uid <- map["Uid"]
        UtipoUsuarioId <- map["UtipoUsuarioId"]
        UfranquiciaId <- map["UfranquiciaId"]
        Unombre <- map["Unombre"]
        Uapellido <- map["Uapellido"]
        UcedulaIdentidad <- map["UcedulaIdentidad"]
        UdireccionNumero <- map["UdireccionNumero"]
        UdireccionApto <- map["UdireccionApto"]
        UdireccionEsquina <- map["UdireccionEsquina"]
        Ucelular <- map["Ucelular"]
        Utelefono <- map["Utelefono"]
        Uemail <- map["Uemail"]
        Uinstituto <- map["Uinstituto"]
        Ucarrera <- map["Ucarrera"]
        UnivelEducativoId <- map["UnivelEducativoId"]
        Ugrado <- map["Ugrado"]
        Uavatar <- map["Uavatar"]
        UskypeId <- map["UskypeId"]
        Cid <- map["Cid"]
        Cnombre <- map["Cnombre"]
        Cdescripcion <- map["Cdescripcion"]
        CmateriaId <- map["CmateriaId"]
        CfranquiciaId <- map["CfranquiciaId"]
        CtipoCuponeraAsociadaId <- map["CtipoCuponeraAsociadaId"]
        Iid <- map["Iid"]
        UMid <- map["UMid"]
        UMfranquiciaId <- map["UMfranquiciaId"]
        UMnombre <- map["UMnombre"]
        ClSMId <- map["ClSMId"]
        UMapellido <- map["UMapellido"]
        UdireccionCalle <- map["UdireccionCalle"]
        horarios <- map["horarios"]
        claseId <- map["claseId"]
    }
    
    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return ""
    }
    
    static func expand() -> String{
        return ""
    }
}

@objc(ScheduleModel)
class ScheduleModel : NSObject, Mappable, Meta
{
    var _id: Int?
    var solicitudId: Int?
    var dia: Int?
    var horarioComienzo: String?
    var horarioFin: String?

    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        _id <- map["id"]
        solicitudId <- map["solicitudId"]
        dia <- map["dia"]
        horarioComienzo <- map["horarioComienzo"]
        horarioFin <- map["horarioFin"]
    }
    
    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return ""
    }
    
    static func expand() -> String{
        return ""
    }
}

@objc(ProfileUpdateModel)
class ProfileUpdateModel : NSObject, Mappable, Meta
{
    var result: UserModel?
    var code: Int?
    var error_message: String?
    
    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        code <- map["code"]
        error_message <- map["error_message"]
    }
    
    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return "usuario/actualizarPerfilUsuario"
    }
    
    static func expand() -> String{
        return ""
    }
}

@objc(RequestAcceptModel)
class RequestAcceptModel : NSObject, Mappable, Meta
{
    var result: UserModel?
    var code: Int?
    var error_message: String?
    
    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        code <- map["code"]
        error_message <- map["error_message"]
    }
    
    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return "solicitud/aceptar"
    }
    
    static func expand() -> String{
        return ""
    }
}

@objc(ClassSetHoursModel)
class ClassSetHoursModel : NSObject, Mappable, Meta
{
    var result: UserModel?
    var code: Int?
    var error_message: String?
    
    override init() {}
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        code <- map["code"]
        error_message <- map["error_message"]
    }
    
    static func queryString() -> String {
        return ""
    }
    
    //Impl. of Meta protocol
    static func url() -> String {
        return "clase/asignar"
    }
    
    static func expand() -> String{
        return ""
    }
}


