from moviepy.editor import VideoFileClip, clips_array


def combine_s3_videos(link1, link2):
    print(link1)
    print(link2)
    return


def combine_local__ideos(video_1_path, video_2_path):
    # Load the video clips
    video1 = VideoFileClip(video_1_path)
    video2 = VideoFileClip(video_2_path)

    # Ensure both videos have the same width
    # video2 = video2.resize(width=video1.w)

    # Stack the videos vertically
    final_video = clips_array([[video1], [video2]])

    # Export the final video
    final_video.write_videofile(
        "output_video.mp4", codec="libx264", audio_codec="aac")

    print('Combining videos')
    return


def main():
    # combineLocalVideos("video1.mp4", "video2.mp4")
    combine_s3_videos("video1.mp4", "video2.mp4")
    return


def lambda_handler(event, context):
    if "video1s3" in event and "video2s3" in event:
        combine_s3_videos(event["video1s3"], event["video2s3"])

        return {
            'statusCode': 200,
            'body': 'Successfully combined videos'
        }
    else:
        return {
            'statusCode': 400,
            'body': 'Provided invalid event. Got: ' + str(event)
        }


if __name__ == '__main__':
    main()
