from google.cloud import language_v1

def sentiment_analysis(text):
    # Instantiates a client
    client = language_v1.LanguageServiceClient()

    document = language_v1.Document(content=text, type_=language_v1.Document.Type.PLAIN_TEXT)

    # Detects the sentiment of the text
    sentiment = client.analyze_sentiment(request={'document': document}).document_sentiment

    output = f'The Google Natural Lanugage API provides a sentiment score of {round(sentiment.score,2)} and sentiment magnitude of {round(sentiment.magnitude,2)} for the input text: {text}'

    return output

if __name__ == '__main__':
    score = sentiment_analysis(u"Hello, world!")
    print(score)
