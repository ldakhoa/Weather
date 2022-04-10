//
//  WeatherListViewController.swift
//  Weather
//
//  Created by Khoa Le on 04/04/2022.
//

import UIKit

/// An object acts upon weathers data and the associated view to display weather info.
protocol WeatherListPresentable {
    /// Notifies the view is about to be added to a view hierarchy.
    func viewWillAppear()

    /// Ask for the number of sections in a table view.
    /// - Returns: The number of sections in a table view.
    func numberOfSections() -> Int

    /// The number of items in a specific section.
    /// - Parameter section: An index number identifying a section.
    /// - Returns: The number of rows in section.
    func numberOfRows(in section: Int) -> Int

    /// The forecast data that corresponds to the specified index path.
    /// - Parameter indexPath: The index path that specifies the location of the user.
    /// - Returns: The forecast that corresponds to index path.
    func forecasts(at indexPath: IndexPath) -> Forecast
    
    /// Notify that the refresh control did change value.
    func didChangeValueRefreshControl()

    /// Search the forecast data by city.
    /// - Parameter city: The name of the city.
    func searchForecasts(byCity city: String)

    /// Cleanup the table view.
    func cleanup()

    /// The temperature degree unit.
    var degreeUnit: DegreeUnit { get }
}

/// A passive view controller displays weather lists.
final class WeatherListViewController: UIViewController, WeatherListViewable {
    // MARK: - UIs

    /// Search controller to help us with filtering the city name.
    private(set) lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.returnKeyType = .done
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a city"
        searchController.searchBar.delegate = self
        searchController.searchBar.accessibilityTraits = .searchField
        searchController.searchBar.accessibilityLabel = "Enter a city to field to search the forecast"
        searchController.searchBar.isAccessibilityElement = true
        return searchController
    }()

    /// A view that manages an ordered collection of data items and presents with the table.
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.keyboardDismissMode = .interactive
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0.0
        }
        view.refreshControl = UIRefreshControl()
        view.refreshControl?.addTarget(
            self,
            action: #selector(didChangeValueRefreshControl),
            for: .valueChanged)
        view.register(WeatherListTableViewCell.self, forCellReuseIdentifier: WeatherListTableViewCell.reuseIdentifier)
        return view
    }()

    /// A view that is laid over the current content to display some messages with an action.
    private(set) lazy var statefulView: StatefulView = {
        let view = StatefulView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// A view that is display over the current content indicates there are some tasks in progress.
    private(set) lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: - Dependencies
    
    /// An object acts upon weathers data and the associated view to display weather info.
    let presenter: WeatherListPresentable

    // MARK: - Init

    /// Initiate a passive controller displays weather list.
    /// - Parameters:
    ///    - presenter: An object acts upon weathers data and the associated view to display weather info.
    init(presenter: WeatherListPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(statefulView)

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            statefulView.topAnchor.constraint(equalTo: view.topAnchor),
            statefulView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statefulView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statefulView.trailingAnchor.constraint(equalTo: view.trailingAnchor)

        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    // MARK: - Side Effects

    private func setupNavigation() {
        title = "Weather Forecast"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    @objc private func didChangeValueRefreshControl() {
        presenter.didChangeValueRefreshControl()
    }

    // MARK: - WeatherListViewable

    func reloadData() {
        self.tableView.reloadData()
    }

    func toggleLoading(_ isEnabled: Bool) {
        tableView.refreshControl?.endRefreshing()
        if isEnabled {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
    }
    
    func showAlert(withTitle title: String) {
        let alertController = UIAlertController(
            title: title,
            message: "",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }

    func toggleStatefulView(withState state: StatefulState) {
        statefulView.isHidden = state == .onHide ? true : false
        statefulView.updateTitle(state)
    }
}

// MARK: - UITableViewDataSource

extension WeatherListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfSections()
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter.numberOfRows(in: section)
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherListTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? WeatherListTableViewCell else {
            fatalError("Failed to dequeue cell with identifier \(WeatherListTableViewCell.reuseIdentifier)")
        }
        cell.update(
            withForecast: presenter.forecasts(at: indexPath),
            unit: presenter.degreeUnit)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WeatherListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        100
    }
}

// MARK: - UISearchBarDelegate

extension WeatherListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.cleanup()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty { presenter.cleanup() }
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(handleSearchForecast),
            object: searchController.searchBar)
        perform(
            #selector(handleSearchForecast),
            with: searchController.searchBar,
            afterDelay: 0.75)
    }

    @objc
    func handleSearchForecast(_ searchBar: UISearchBar) {
        guard
            let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            query.count >= 3
        else {
            return
        }
        presenter.searchForecasts(byCity: query)
    }
}
