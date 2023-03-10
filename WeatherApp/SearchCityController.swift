//
//  FiAssignmentWeatherAppApp.swift
//  FiAssignmentWeatherApp
//
//  Created by Pratyush Jha on 08/03/23.
//

import UIKit

final class SearchCityController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate: GetCityProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchCityController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CityData.shared.storeCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = CityData.shared.storeCity[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        guard let cell = cell else { return }
        self.dismiss(animated: false)
        guard let cityName = cell.textLabel, let cityText = cityName.text  else { return }
        self.delegate?.getCity(cityDetail: cityText)
    }
}

extension SearchCityController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let appendedCity = searchBar.text {
            CityData.shared.operationInStoreCity(city: appendedCity)
            tableView.reloadData()
        }
    }
}

