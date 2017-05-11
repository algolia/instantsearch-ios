import UIKit
import InstantSearchCore
import InstantSearch

class ViewController: UIViewController, HitTableViewDataSource, HitTableViewDelegate {
    
    var instantSearchBinder: InstantSearch!
    @IBOutlet weak var hitsTable: HitsTableWidget!
    var hitsViewController: HitsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsViewController = HitsViewController(table: hitsTable)
        hitsTable.dataSource = hitsViewController
        hitsTable.delegate = hitsViewController
        hitsViewController.tableDataSource = self
        hitsViewController.tableDelegate = self
        
        instantSearchBinder = AlgoliaSearchManager.instance.instantSearchBinder
        instantSearchBinder.addAllWidgets(in: self.view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = hitsTable.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        
        cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        cell.textLabel?.highlightedTextColor = .black
        cell.textLabel?.highlightedBackgroundColor = .yellow
        
        cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String: Any]) {
        print("hit \(String(describing: hit["name"]!)) has been clicked")
    }
    
}
