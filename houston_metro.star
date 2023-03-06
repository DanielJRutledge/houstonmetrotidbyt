load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("secret.star", "secret")
load("schema.star", "schema")

def main():
    key = secret.decrypt("AV6+xWcELB7fdgsWq+ac5A5IhLoyqFh0HBLYkpIWpeKaNQDprydIHNzDbKBOrollp1t8GtFlIk0Q1eyS1u8C05F6ZEK3DVsosQiVMtbZHuVW8Uk9y8APabLfnNybEApexnd6r6s6sJKXmUYsDUh3XZaf+5Nzd85377amp8Ywvvm8jcJpmSg=")
    stop_id = "Ho414_4620_619"
    endpoint = "https://api.ridemetro.org/data/Stops('"+stop_id+"')/Arrivals?subscription-key="+key

    METRO_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAABUAAAAMCAYAAACNzvbFAAAAAXNSR0IArs4c6QAAAE5JREFUOE9jZKABYCRkpm/u5//Y1CxYb4hVq/CTO4x4DSXHQJBNOA0l10CchlJiIF6XEgprfPIY3qfUlRgupYaBtPc+tVwJdyk1DaSZ9wEBvjANhhbdqgAAAABJRU5ErkJggg==
""")

    # Make the initial GET request
    response = http.get(endpoint)

    render_elements = []
    i = 0
    while i != 4:
        if response.json()["value"]:
            if response.json()["value"][i]:
                route_number = response.json()["value"][i]["RouteName"]
                stop_name = response.json()["value"][i]["StopName"]
                arrival_time = response.json()["value"][i]["LocalArrivalTime"]
                route_id = response.json()["value"][i]["RouteId"]
                arrival_time = time_string(arrival_time)

                route_info_endpoint = "https://api.ridemetro.org/data/FullRouteInfo?routeId="+route_id+"&subscription-key="+key
                route_info_response = http.get(route_info_endpoint)

                route_color = route_info_response.json()['RouteColor']

                render_element = render.Row(children = [
                            render.Stack(children = [
                                render.Box(
                                    color = "#" + route_color,
                                    width = 22,
                                    height = 10,
                                ),
                                render.Box(
                                    color = "#0000",
                                    width = 22,
                                    height = 10,
                                    child = render.Text(route_number, color = "#000", font = "CG-pixel-4x5-mono"),
                                ),
                            ]),
                            render.Column(
                                children = [
                                    render.Text(" " + arrival_time, color = "#f3ab3f"),
                                ],
                            )
                        ],
                        main_align = "center",
                        cross_align = "center"
                    )
            render_elements.append(render_element)

    frame_1 = render.Column(
        children = [
            render_element[0],
            render_element[1]
        ]
    )
    if render_element[2]:
        frame_2 = render.Column(
            children = [
                render_element[2],
                render_element[3]
            ]
        )

    animation_children = []

    i = 0
    while i != 80:
        animation_children.append(frame_1)
        i+=1;
    
    while i != 160:
        if frame_2:
            animation_children.append(frame_2)
        else:
            animation_children.append(frame_1)
        i+=1

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
                                    font = "tb-8",
                                    height = 12
                                ),
                            align = "center",
                            width = 45,
                            offset_start=5,
                            offset_end=32,
                        ),
                    ]
                ),
                render.Sequence(
                    children = [
                        render.Animation(
                            children = animation_children
                        )
                    ]
                ),
            ]
        )
    )

def time_string(full_string):
    time_index = full_string.find('T')
    return full_string[time_index+1:len(full_string)-4]


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