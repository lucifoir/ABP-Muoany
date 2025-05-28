from flask import Flask, request, jsonify
import joblib

model = joblib.load('text_classification_model.pkl')
vectorizer = joblib.load('tfidf_vectorizer.pkl')

app = Flask(__name__)

@app.route('/')
def home():
    return "Text Classification API is running!"

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    
    title = data.get('title')
    print(f"Received title: {title}")
    print("pantek")
    if not title:
        return jsonify({"error": "Title is required"}), 400
    
    X = vectorizer.transform([title])
    prediction = model.predict(X)[0]
    
    return jsonify({
        "title": title,
        "predicted_category": prediction
    })

if __name__ == '__main__':
    app.run(port=5001, debug=True)
