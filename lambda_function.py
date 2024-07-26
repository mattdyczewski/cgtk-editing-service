def combineVideos(video1, video2):
    print('Combining videos')
    return


def main():
    combineVideos("video1.mp4", "video2.mp4")
    return


def lambda_handler(event, context):
    print('hello world')
    main()
    return {
        'statusCode': 200,
        'body': 'Hello from Lambda! + Upload'
    }


if __name__ == '__main__':
    main()
