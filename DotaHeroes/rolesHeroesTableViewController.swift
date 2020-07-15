//
//  rolesHeroesTableViewController.swift
//  DotaHeroes
//
//  Created by Eka Praditya Giovanni Kariim on 14/07/2020.
//  Copyright © 2020 teravin. All rights reserved.
//

import UIKit

class rolesHeroesTableViewController: UITableViewController {
    public var dataHeroes = Array<Any>()
    var rolesHeroes = Array<Any>()
    var dictRolesHeroes = [Int : String]()
    var selectedHeroes = Array<Any>()
    @IBOutlet var rolesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rolesTable.register(UINib(nibName: "rolesHeroesViewCell", bundle: nil), forCellReuseIdentifier: "NameCell")

//        print(arr[0])
        for i in 0 ..< dataHeroes.count{
            let allDataHeroes = dataHeroes[i] as! [String:Any]
            let rolesArr = allDataHeroes["roles"] as! [String]
            for j in 0 ..< rolesArr.count{
                if self.rolesHeroes.contains(where: { $0 as! String == rolesArr[j] }) == false {
                    self.rolesHeroes.append(rolesArr[j])
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.rolesTable.delegate = self
        self.rolesTable.dataSource = self
        self.rolesTable.reloadData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.rolesHeroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: rolesHeroesViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath as IndexPath) as? rolesHeroesViewCell
        cell?.roleText.text = self.rolesHeroes[indexPath.row] as? String
        self.dictRolesHeroes[indexPath.row] = self.rolesHeroes[indexPath.row] as! String
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showHeroesBasedonRoles(Roles: self.dictRolesHeroes[indexPath.row]!)
    }
    
    func showHeroesBasedonRoles(Roles:String){
        self.selectedHeroes.removeAll()
        for i in 0 ..< dataHeroes.count{
            let allDataHeroes = dataHeroes[i] as! [String:Any]
            let rolesArr = allDataHeroes["roles"] as! [String]
            for j in 0 ..< rolesArr.count{
                if rolesArr.contains(where: { $0 as! String == Roles }) {
                    self.selectedHeroes.append(dataHeroes[i])
                }
            }
        }
        self.getHeroAttributebyIDHero(arrNumber: 3)
    }
    
    func getHeroAttributebyIDHero(arrNumber:Int){
        let selectedHero = selectedHeroes[arrNumber] as! [String:Any]
        self.pick3SimilarHeroesbyAttr(attr: selectedHero["primary_attr"] as! String)
    }
    
    func pick3SimilarHeroesbyAttr(attr:String){
        print(attr)
        var primaryAttrHeroes = Array<Any>()
        for i in 0 ..< dataHeroes.count{
            let allDataHeroes = dataHeroes[i] as! [String:Any]
            let hero = allDataHeroes["primary_attr"] as! String
                if hero == attr {
                    primaryAttrHeroes.append(dataHeroes[i])
                }
        }
        
        // get base stat
        var baseStatHighList = Array<Int>()
        for k in 0 ..< primaryAttrHeroes.count{
            let hero = primaryAttrHeroes[k] as! [String:Any]
            let value = hero["base_"+attr] as! Int
            baseStatHighList.append(value)
        }
        
        // get top 3
        var array2 = baseStatHighList.sorted(){ $0 > $1}
        let firstMax = array2.removeFirst()
        let secondMax = array2.removeFirst()
        let thirdMax = array2.removeFirst()
        let top3Stat = [firstMax,secondMax,thirdMax]
        
        // get top 3 heroes
        var top3Heroes = Array<Any>()
        for l in 0 ..< primaryAttrHeroes.count{
            let hero = primaryAttrHeroes[l] as! [String:Any]
            let value = hero["base_"+attr] as! Int
            if top3Stat.contains(value){
                top3Heroes.append(hero)
            }
        }
        
        for heroes in 0..<top3Heroes.count{
            let hero = top3Heroes[heroes] as! [String:Any]
            print(hero["localized_name"])
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
