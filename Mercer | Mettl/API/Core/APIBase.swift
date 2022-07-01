//
//  APIBase.swift
//  Dev_Mercer_Mettl
//
//  Created by m@k-ios on 20/05/22.
//

import Foundation

/// API Version
public enum APIVersion {
    var version: String {
        switch self {
        case .v1:
            return "v1/"
        case .v2:
            return "v2/"
        }
    }
    case v1
    case v2
}

/// API Enviroment
public enum Environment {
    var host: String {
        switch self {
        case .dev:
            return "https://tests.mettl.xyz"
        case .staging:
            return "https://tests.mettl.com"
        case .production:
            return "https://tests.mettl.pro"
        }
    }
    
    case staging
    case dev
    case production
}

let APIEnvironment: Environment = .dev
typealias APIResult<T:Codable> = (_ result:T?, _ error:APIError?) -> Void

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum Parameters {
    case none
    case body(data: Data?)
    case url(_: [String: String])
}

final class SessionDispatcher: NSObject, URLSessionDelegate {
    var headers: [String: String] = [:]
    let host: String
    var apiRequest: RequestRepresentable!
    
    override init() {
        self.host = APIEnvironment.host
    }
    
    var session: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let s = URLSession(configuration: config)
        return s
    }
    
    func execute<T:Decodable>(requst: RequestRepresentable, modeling _: T.Type, completion:@escaping APIResult<T>) {
        switch requst.parameters {
        case let .body (data):
            if let obj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) {
                print("parameters of request",obj)
            }
        default:
            break
        }
        
        let  task = session.dataTask(with: prepareRequest(request: requst), completionHandler: { data, http, err in
            if err != nil { completion(nil, APIError(errorCode: .uknown, responseData: APIErroResponseData(message: err?.localizedDescription, error: err?.localizedDescription), statusCode: 0)) }
            guard let  resp = http as? HTTPURLResponse else {
                completion(nil, APIError(errorCode: .uknown, responseData: nil, statusCode: 0))
                return
            }
            
            guard let data = data else {
                completion(nil, APIError(errorCode: .uknown, responseData: nil, statusCode: resp.statusCode))
                return
            }
            if let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                print(obj)
            }
            self.handleReponse(data: data, response: resp, completion: completion)
        })
        task.resume()
    }
    
    private func handleErrorMessage(errorCode: ErrorCode) -> String {
        switch errorCode {
        case .authorize:
            return AppConstant.AuthorizeErrorMessage
        case .badRequest:
            return AppConstant.BadRequesErrorMessage
        case .network:
            return AppConstant.NetworkErrorMessage
        case .parsing:
            return AppConstant.ParsingErrorMessage
        case .server:
            return AppConstant.ServerErrorMessage
        default:
            return AppConstant.ErrorMessage
        }
    }
    
    func handleReponse<T:Codable>(data:Data, response:HTTPURLResponse,completion:@escaping APIResult<T>) {
        print("received response status code:\(response.statusCode)")
        let (ok, code) = statusOK(response: response)
        if !ok {
            let error = APIError(errorCode: code, responseData: APIErroResponseData(message: handleErrorMessage(errorCode: code), error: handleErrorMessage(errorCode: code)), statusCode: response.statusCode)
            print(error)
            completion(nil, error)
            return
        }
        
        let (model, err) = Parser<T>.from(data)
        if err == nil {
            completion(model, nil)
            return
        }
        
        if let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            print(obj)
        }
        completion(nil, APIError(errorCode: .parsing, responseData: nil, statusCode: response.statusCode))
    }
    
    func statusOK(response: HTTPURLResponse) -> (Bool, ErrorCode) {
        var code:ErrorCode
        var ok:Bool
        switch response.statusCode {
        case 200,203,201:
            code = .uknown
            ok = true
        case 403:
            code = .authorize
            ok = false
        case 400:
            code = .badRequest
            ok = false
        case 500,502 :
            code = .server
            ok = false
        default:
            code  = .uknown
            ok = false
        }
        return (ok, code)
    }
    
    private func prepareRequest(request: RequestRepresentable) -> URLRequest {
        let s = "\(host)/api/\(APIVersion.v1)/\(request.endpoint)"
        let scaped = s.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: scaped!)
        var r = URLRequest(url: url!)
        self.headers(in: request, for: &r)
        self.params(in: request, for: &r)
        print("sending header:", headers)
        print("sending request:", s)
        return r
    }
    
    
    private func headers(in request: RequestRepresentable, for urlRequest: inout URLRequest) {
        urlRequest.httpMethod = request.method.rawValue
        addDefaultHeaders()
        headers.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
        })
        request.headers?.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
        })
    }
    
    private func addDefaultHeaders() {
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["Origin"] = self.host
        headers["Referer"] = (self.host) + "/\(APIVersion.v2)/"
      }
    
    private func params(in request: RequestRepresentable, for urlRequest: inout URLRequest) {
        switch request.parameters {
        case let .body(data):
            urlRequest.httpBody = data
            
        case let .url(urlencoded):
            var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
            urlencoded.forEach { key, value in
                let query = URLQueryItem(name: key, value: value)
                urlComponents?.queryItems?.append(query)
            }
            urlRequest = URLRequest(url: (urlComponents?.url)!)
        case .none: break
        }
    }
}


