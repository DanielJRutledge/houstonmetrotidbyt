load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("secret.star", "secret")
load("schema.star", "schema")

def main():
    key = secret.decrypt("AV6+xWcELB7fdgsWq+ac5A5IhLoyqFh0HBLYkpIWpeKaNQDprydIHNzDbKBOrollp1t8GtFlIk0Q1eyS1u8C05F6ZEK3DVsosQiVMtbZHuVW8Uk9y8APabLfnNybEApexnd6r6s6sJKXmUYsDUh3XZaf+5Nzd85377amp8Ywvvm8jcJpmSg=")
    stop_id = "Ho414_4620_2956"
    
    endpoint = "https://api.ridemetro.org/data/Stops('Ho414_4620_2956')/Arrivals?subscription-key=" + key

    METRO_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAB0AAAAKCAYAAABIQFUsAAAAAXNSR0IArs4c6QAAAFRJREFUOE9jZMADfHM//8cnD5PbPJmXEcR+K6NClHqwYmyAVhYKP7nDiNVSWloI8iCGpbS2EKulxMQhpWpQfEoPX6L4lF4WDmzw0tOXYJ/S20KQpQDB3j43KdSNLgAAAABJRU5ErkJggg==
""")

    # Make the initial GET request
    response = http.get(endpoint)

    route_number = response.json()["value"][0]["RouteName"]
    stop_name = response.json()["value"][0]["StopName"]
    arrival_time = response.json()["value"][0]["LocalArrivalTime"]
    route_id = response.json()["value"][0]["RouteId"]
    time_index = arrival_time.find('T')
    arrival_time = arrival_time[time_index+1:len(arrival_time)-4]

    route_number2 = response.json()["value"][1]["RouteName"]
    arrival_time2 = response.json()["value"][1]["LocalArrivalTime"]
    route_id2 = response.json()["value"][1]["RouteId"]

    arrival_time2 = arrival_time2[time_index+1:len(arrival_time2)-4]

    route_info_endpoint = "https://api.ridemetro.org/data/FullRouteInfo?routeId="+route_id+"&subscription-key=" + key
    route_info2_endpoint = "https://api.ridemetro.org/data/FullRouteInfo?routeId="+route_id+"&subscription-key=" + key

    route_info_response = http.get(route_info_endpoint)
    route_info_response2 = http.get(route_info2_endpoint)

    route_color = route_info_response.json()['RouteColor']
    route_color2 = route_info_response2.json()['RouteColor']

    return render.Root(
        child = render.Column(
            children = [
                render.Row(
                    children = [
                        render.Image(
                            src=METRO_ICON
                        ),
                        render.Marquee(
                            child =
                                render.Text(
                                    stop_name,
                                    font = "Dina_r400-6",
                                    height = 12
                                ),
                            width = 45,
                            offset_start=5,
                            offset_end=32,
                        ),
                    ]
                ),
                render.Row(
                    children = [
                        render.Stack(children = [
                            render.Box(
                                color = "#" + route_color,
                                width = 22,
                                height = 9,
                            ),
                            render.Box(
                                color = "#0000",
                                width = 22,
                                height = 9,
                                child = render.Text(route_number, color = "#000", font = "CG-pixel-4x5-mono"),
                            ),
                        ]),
                        render.Column(
                            children = [
                                render.Text(arrival_time, color = "#f3ab3f"),
                            ],
                        )
                    ],
                    main_align = "center",
                    cross_align = "center"
                ),
                render.Row(
                    children = [
                        render.Stack(children = [
                            render.Box(
                                color = "#" + route_color2,
                                width = 22,
                                height = 9,
                            ),
                            render.Box(
                                color = "#0000",
                                width = 22,
                                height = 9,
                                child = render.Text(route_number2, color = "#000", font = "CG-pixel-4x5-mono"),
                            ),
                        ]),
                        render.Column(
                            children = [
                                render.Text(arrival_time2, color = "#f3ab3f"),
                            ],
                        )
                    ],
                    main_align = "center",
                    cross_align = "center"
                ),
            ]
        )
    )

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.Text(
                id = "Location",
                name = "Location",
                desc = "Location",
                icon = "Location",
            ),
        ],
    )