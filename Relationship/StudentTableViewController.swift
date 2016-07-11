//
//  StudentTableViewController.swift
//

import UIKit
import CoreData

class StudentTableViewController: UITableViewController {

    //管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    
    //検証用データ（生徒一覧）
    let studentList = [[1,"佐藤", 29, "野球部"],
                    [2,"田中", 20, "サッカー部"],
                    [3,"中西", 37, "野球部"],
                    [4,"鈴木", 24, "野球部"],
                    [5,"高橋", 21, "サッカー部"],
                    [6,"伊藤", 30, "テニス部"]]

    //検証用データ（部一覧）
    let clubList = [["野球部", 32000, "花田球場", "火水"],
                    ["サッカー部", 25000, "日野グラウンド", "月木金"],
                    ["テニス部", 18000, "千代田コート", "水"]]

    //検索結果配列
    var searchResult = [Student]()
    

    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()

        //管理オブジェクトコンテキストを取得する。
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = applicationDelegate.managedObjectContext
        
        //検証用データを保存する。
        insertData()
        
        //検索結果配列にデータを格納する。
        makeSearchResult()
        
        //テーブルビューを再読み込みする。
        self.tableView.reloadData()
    }
    
    
 
    //検証用データを保存するメソッド
    func insertData(){
        
        do {
            //管理オブジェクトコンテキストの中のオブジェクトの件数を取得する。。
            let fetchRequest = NSFetchRequest(entityName: "Student")
            fetchRequest.resultType = .CountResultType
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [Int]
            
            if(result[0] == 0){

                //何も保存されていない場合は検証用データを保存する。
                for data in studentList {
                    let student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: managedContext) as! Student
                    student.number = data[0] as? Int    //番号
                    student.name = data[1] as? String   //名前
                    student.age = data[2] as? Int       //年齢
                }
                
                //管理オブジェクトコンテキストの中身を保存する。
                try managedContext.save()
            }
            
        } catch {
            print(error)
        }
    }
    
    

    //検索結果配列作成メソッド
    func makeSearchResult() {
        
        //検索結果配列を空にする。
        searchResult.removeAll()
        
        //フェッチリクエストのインスタンスを生成する。
        let fetchRequest = NSFetchRequest(entityName: "Student")
        
        do {
            //フェッチリクエストを実行する。
            searchResult = try managedContext.executeFetchRequest(fetchRequest) as! [Student]

        } catch {
            print(error)
        }
    }



    //データの個数を返すメソッド
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }



    //データを返すメソッド
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //セルを取得する。
        let cell = tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath:indexPath) as UITableViewCell
        
        //セルのラベルに本のタイトルを設定する。
        let student = searchResult[indexPath.row]
        cell.textLabel?.text = "No.\(student.number!)　\(student.name!)　\(student.age!)"
        
        return cell
    }



    //編集可否を答えるメソッド
    override func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        //すべての行を編集可能にする。
        return true
    }
    
    
    
    //テーブルビュー編集時の呼び出しメソッド
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            do {
                //選択行のオブジェクトを管理オブジェクトコンテキストから取得する。
                let fetchRequest = NSFetchRequest(entityName: "Student")
                fetchRequest.predicate = NSPredicate(format:"name = %@", searchResult[indexPath.row].name!)
                
                if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Student] {
                    
                    //検索結果配列から選択行のオブジェクトを削除する。
                    searchResult.removeAtIndex(indexPath.row)
                    
                    //テーブルビューから選択行を削除する。
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    
                    //管理オブジェクトコンテキストから選択行のオブジェクトを削除する。
                    managedContext.deleteObject(result[0])
                    
                    //管理オブジェクトコンテキストの中身を保存する。
                    try managedContext.save()
                }
            } catch {
                print(error)
            }
        }
    }
}
