import UIKit
import InstantSearchCore
import InstantSearch

class ViewController: UIViewController, HitsTableViewDataSource, HitsTableViewDelegate {
    
    var instantSearch: InstantSearch!
    @IBOutlet weak var hitsTable: HitsTableWidget!
    var hitsController: HitsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitsController = HitsController(table: hitsTable)
        hitsTable.dataSource = hitsController
        hitsTable.delegate = hitsController
        hitsController.tableDataSource = self
        hitsController.tableDelegate = self
        
        instantSearch = InstantSearch.reference
        instantSearch.addAllWidgets(in: self.view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String : Any]) -> UITableViewCell {
        let cell = hitsTable.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath)
        
        cell.textLabel?.text = hit["name"] as? String
        cell.textLabel?.isHighlightingInversed = true
        cell.textLabel?.highlightedTextColor = .black
        cell.textLabel?.highlightedBackgroundColor = .yellow
        cell.textLabel?.highlightedText = SearchResults.highlightResult(hit: hit, path: "name")?.value
        
        
        cell.detailTextLabel?.text = String(hit["salePrice"] as! Double)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, containing hit: [String: Any]) {
        print("hit \(String(describing: hit["name"]!)) has been clicked")
    }
    
    func viewForNoResults(in tableView: UITableView) -> UIView {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                         width: tableView.bounds.size.width,
                                                         height: tableView.bounds.size.height))
        noDataLabel.text          = "HEY! NO RESULTS!"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .left
        
        return noDataLabel
    }
}
