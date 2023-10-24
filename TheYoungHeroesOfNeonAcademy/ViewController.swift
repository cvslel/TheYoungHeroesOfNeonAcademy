//
//  ViewController.swift
//  TheYoungHeroesOfNeonAcademy
//
//  Created by Cenker Soyak on 23.10.2023.
//

import UIKit
import CoreData
import SnapKit

class ViewController: UIViewController {
    
    let nameTextfield = UITextField()
    let surnameTextfield = UITextField()
    let ageTextfield = UITextField()
    let emailTextfield = UITextField()
    let saveAllButton = UIButton()
   
    var nameArray = [String]()
    var surnameArray = [String]()
    var ageArray = [Int16]()
    var emailArray = [String]()
    var userInfoArray = [String]()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        getData()
    }
    
    func createUI(){
        view.backgroundColor = .white
        
        view.addSubview(nameTextfield)
        nameTextfield.placeholder = "Enter your name: "
        nameTextfield.borderStyle = .roundedRect
        nameTextfield.layer.borderColor = UIColor.black.cgColor
        nameTextfield.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
        }
        
        view.addSubview(surnameTextfield)
        surnameTextfield.placeholder = "Enter your surname: "
        surnameTextfield.borderStyle = .roundedRect
        surnameTextfield.layer.borderColor = UIColor.black.cgColor
        surnameTextfield.snp.makeConstraints { make in
            make.top.equalTo(nameTextfield.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
        }
        view.addSubview(ageTextfield)
        ageTextfield.placeholder = "Enter your age: "
        ageTextfield.borderStyle = .roundedRect
        ageTextfield.layer.borderColor = UIColor.black.cgColor
        ageTextfield.snp.makeConstraints { make in
            make.top.equalTo(surnameTextfield.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
        }
        emailTextfield.placeholder = "Enter your e-mail: "
        emailTextfield.borderStyle = .roundedRect
        emailTextfield.layer.borderColor = UIColor.black.cgColor
        view.addSubview(emailTextfield)
        emailTextfield.snp.makeConstraints { make in
            make.top.equalTo(ageTextfield.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
        }
        
        saveAllButton.setTitle("Save", for: .normal)
        saveAllButton.configuration = .filled()
        saveAllButton.addTarget(self, action: #selector(saveAllTapped), for: .touchUpInside)
        view.addSubview(saveAllButton)
        saveAllButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextfield.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(saveAllButton.snp.bottom).offset(25)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            nameArray.removeAll()
            surnameArray.removeAll()
            ageArray.removeAll()
            emailArray.removeAll()
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String{
                    self.nameArray.append(name)
                }
                if let surname = result.value(forKey: "surname") as? String {
                    self.surnameArray.append(surname)
                }
                if let age = result.value(forKey: "age") as? Int16 {
                    self.ageArray.append(age)
                }
                if let email = result.value(forKey: "email") as? String {
                    self.emailArray.append(email)
                }
                if let name = nameArray.last, let lastname = surnameArray.last,
                   let age = ageArray.last, let email = emailArray.last {
                }
                tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    @objc func saveAllTapped(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        
        newUser.setValue(nameTextfield.text, forKey: "name")
        newUser.setValue(surnameTextfield.text, forKey: "surname")
        newUser.setValue(Int16(ageTextfield.text ?? "0"), forKey: "age")
        newUser.setValue(emailTextfield.text, forKey: "email")
        
        do {
            try context.save()
            print("saved")
            getData()
            
        } catch  {
            print("Error")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:  indexPath)
        cell.textLabel?.text = "\(nameArray[indexPath.row]) \(surnameArray[indexPath.row]) \(ageArray[indexPath.row]) \(emailArray[indexPath.row])"
        return cell
    }
}

