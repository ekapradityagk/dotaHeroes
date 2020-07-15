//
//  ViewController.swift
//  DotaHeroes
//
//  Created by Eka Praditya Giovanni Kariim on 14/07/2020.
//  Copyright © 2020 teravin. All rights reserved.
//

import UIKit

struct Heroe: Codable {
    var id: String
    var name: String
    var localized_mame: String
}
var dataEmojies = [Emoji]()
var dataImage = [dataImages]()

class ViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(dataImage.count)
        return dataImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewCellHeroes", for: indexPath) as! heroesThumbCollectionViewCell
        
        let dataHero = dataImage[indexPath.row]
        if let name = cell.nameHeroes{
            name.text = dataHero.title
        }
        
        if let image = cell.imageHeroes{            
            let url = URL(string: dataHero.imageName)!

            // Create Data Task
            let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        // Create Image and Update Image View
                        image.image = UIImage(data: data)
                    }
                }
            }

            // Start Data Task
            dataTask.resume()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped in")
        print(indexPath.row)
        print(collectionView.cellForItem(at: indexPath))
    }
    
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var thumbHeroes: UICollectionView!
    
    let columnLayout = ColumnFlowLayout (
        cellsPerRow: 3,
        minimumInteritemSpacing: 0,
        minimumLineSpacing: 0,
        sectionInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbHeroes.collectionViewLayout = columnLayout
        thumbHeroes.contentInsetAdjustmentBehavior = .always
        thumbHeroes.delegate = self
        thumbHeroes.dataSource = self
        self.initDataEmoji()
        self.getHeroes(){ result in
            DispatchQueue.main.async {
                let roleHeroes = rolesHeroesTableViewController()
                let dataAllHeroes = result["data heroes"] as! [Any]
                roleHeroes.dataHeroes = dataAllHeroes

                self.addChild(roleHeroes)
                self.sideView.addSubview(roleHeroes.view)
                roleHeroes.didMove(toParent: self)
                
                for i in 0 ..< dataAllHeroes.count{
                    let dataHeroes = dataAllHeroes[i] as! [String : Any]
                    let heroName = dataHeroes["localized_name"] as! String
                    let image = dataHeroes["img"] as! String
                    let endpoint = "https://api.opendota.com"
                    let hero = dataImages(title: heroName, imageName: endpoint+image)
                    dataImage.append(hero)
                }
//                print(dataImage)
                self.thumbHeroes.reloadData()
            }
        }

    }
    
    func initDataEmoji() {
        print("init data ")
        let angry = Emoji(title: "Angry", imageName: "angry")
        let bored = Emoji(title: "Bored", imageName: "bored")
        let confused = Emoji(title: "Confused", imageName: "confused")
        let crying = Emoji(title: "Crying", imageName: "crying")
        let happy = Emoji(title: "Happy", imageName: "happy")
        let kissing = Emoji(title: "Kissing", imageName: "kissing")
        let meh = Emoji(title: "Meh", imageName: "meh")
        let ninja = Emoji(title: "Ninja", imageName: "ninja")
        let sad = Emoji(title: "Sad", imageName: "sad")
        let surprised = Emoji(title: "Surprised", imageName: "surprised")
        let tongue = Emoji(title: "Tongue", imageName: "tongue")
        let unhappy = Emoji(title: "Unhappy", imageName: "unhappy")
        let wink = Emoji(title: "Wink", imageName: "wink")
     
     dataEmojies.append(angry)
     dataEmojies.append(bored)
     dataEmojies.append(confused)
     dataEmojies.append(crying)
     dataEmojies.append(happy)
     dataEmojies.append(kissing)
     dataEmojies.append(meh)
     dataEmojies.append(ninja)
     dataEmojies.append(sad)
     dataEmojies.append(surprised)
     dataEmojies.append(tongue)
     dataEmojies.append(unhappy)
     dataEmojies.append(wink)
     
     // trigger refresh collection view
     thumbHeroes.reloadData()
    }
    
    func getHeroes(  completionHandler: @escaping (_ result: [String: Any]) -> Void){
        let url = URL(string: "https://api.opendota.com/api/herostats")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          // your code here

            if let error = error {
              print("Error with fetching films: \(error)")
              return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(response)")
              return
            }

            let jsond = JSON(data as Any)
            let dataArr = jsond.arrayObject
            completionHandler(["data heroes":dataArr])

        })
        task.resume()
    }
    
}

