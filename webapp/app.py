from flask import Flask, render_template, request#, url_for, redirect
from analysis import sentiment_analysis
import os

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/InsertText')
def InsertText():
    return render_template('InsertText.html')

@app.route('/InsertText', methods=['POST'])
def InsertTextPost():
    text = request.form['Text_Input']
    output = sentiment_analysis(text)
    return render_template('InsertTextPost.html', output=output)

PORT = int(os.environ.get("PORT", 8080))

if __name__ == '__main__':
    app.run(threaded=True,host='0.0.0.0',port=PORT)