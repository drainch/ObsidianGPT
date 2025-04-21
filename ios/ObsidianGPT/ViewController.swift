import UIKit

class ViewController: UIViewController {

    let apiUrl = "https://example.com/api" // Replace with your actual API URL

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        let fetchButton = UIButton(type: .system)
        fetchButton.setTitle("Fetch Notes", for: .normal)
        fetchButton.addTarget(self, action: #selector(fetchNotes), for: .touchUpInside)
        fetchButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(fetchButton)

        NSLayoutConstraint.activate([
            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func fetchNotes() {
        guard let url = URL(string: "\(apiUrl)/notes") else { return }

        var request = URLRequest(url: url)
        request.setValue("your-api-key", forHTTPHeaderField: "X-API-KEY") // Replace with your actual API key

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching notes: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let notes = try JSONDecoder().decode([String].self, from: data)
                DispatchQueue.main.async {
                    self.showNotes(notes)
                }
            } catch {
                print("Error decoding notes: \(error)")
            }
        }

        task.resume()
    }

    func showNotes(_ notes: [String]) {
        let alertController = UIAlertController(title: "Notes", message: notes.joined(separator: "\n"), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
