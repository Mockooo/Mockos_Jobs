$(function () {
    function display(bool, job) {
        if (bool) {
            $("body").fadeIn(300);
            $(job).show();
        } else {
            $("body").fadeOut(1);
            $(job).hide();
        }
    }

    display(false, ".Busfahrer")
    display(false, ".Elektriker")
    display(false, ".Cargo")

    window.addEventListener("message", function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true, item.job)
            } else {
                display(false, item.job)
            }
        }
        if(item.type == "Passagiere") {
            var place = item.place
            var name = item.name
            var number = item.number

            var placeelement = document.createElement("div");
            var nameelement = document.createElement("div");
            var numberelement = document.createElement("div");
            placeelement.innerHTML = place;
            nameelement.innerHTML = name;
            numberelement.innerHTML = number;
            placeelement.classList.add("Ranglisteneintrag");
            nameelement.classList.add("Ranglisteneintrag");
            numberelement.classList.add("Ranglisteneintrag");
            document.getElementById('PassagierePlace').appendChild(placeelement);
            document.getElementById('PassagiereName').appendChild(nameelement);
            document.getElementById('PassagiereNumber').appendChild(numberelement);
        }
        if(item.type == "Fahrten") {
            var place = item.place
            var name = item.name
            var number = item.number

            var placeelement = document.createElement("div");
            var nameelement = document.createElement("div");
            var numberelement = document.createElement("div");
            placeelement.innerHTML = place;
            nameelement.innerHTML = name;
            numberelement.innerHTML = number;
            placeelement.classList.add("Ranglisteneintrag");
            nameelement.classList.add("Ranglisteneintrag");
            numberelement.classList.add("Ranglisteneintrag");
            document.getElementById('FahrtenPlace').appendChild(placeelement);
            document.getElementById('FahrtenName').appendChild(nameelement);
            document.getElementById('FahrtenNumber').appendChild(numberelement);

        }
        if(item.type == "Routen") {
            var Number = item.number
            var Name = item.name
            var Stops = item.stops
            var Zahlung = item.zahlung

            if (Number == 5) {
                document.getElementById('Routen').classList.add("RoutenScroll");
            }

            var numberelement = document.createElement("button");
            var nameelement = document.createElement("div");
            var stopselement = document.createElement("div");
            var zahlungelement = document.createElement("div");
            nameelement.innerHTML = Name;
            stopselement.innerHTML = "Stops: "+Stops;
            zahlungelement.innerHTML = "Zahlung: "+Zahlung;
            numberelement.classList.add("Route"+Number);
            nameelement.classList.add("Name");
            stopselement.classList.add("Stops");
            zahlungelement.classList.add("Zahlung");
            document.getElementById('Routen').appendChild(numberelement);
            numberelement.appendChild(nameelement);
            numberelement.appendChild(stopselement);
            numberelement.appendChild(zahlungelement);

            numberelement.onclick = function() { RouteButtonClicked(Number); };
        }
        if(item.type == "Repariert") {
            var place = item.place
            var name = item.name
            var number = item.number

            var placeelement = document.createElement("div");
            var nameelement = document.createElement("div");
            var numberelement = document.createElement("div");
            placeelement.innerHTML = place;
            nameelement.innerHTML = name;
            numberelement.innerHTML = number;
            placeelement.classList.add("ElektrikerRanglisteneintrag");
            nameelement.classList.add("ElektrikerRanglisteneintrag");
            numberelement.classList.add("ElektrikerRanglisteneintrag");
            document.getElementById('RepariertPlace').appendChild(placeelement);
            document.getElementById('RepariertName').appendChild(nameelement);
            document.getElementById('RepariertNumber').appendChild(numberelement);
        }
        if(item.type == "Container") {
            var place = item.place
            var name = item.name
            var number = item.number

            var placeelement = document.createElement("div");
            var nameelement = document.createElement("div");
            var numberelement = document.createElement("div");
            placeelement.innerHTML = place;
            nameelement.innerHTML = name;
            numberelement.innerHTML = number;
            placeelement.classList.add("CargoRanglisteneintrag");
            nameelement.classList.add("CargoRanglisteneintrag");
            numberelement.classList.add("CargoRanglisteneintrag");
            document.getElementById('ContainerPlace').appendChild(placeelement);
            document.getElementById('ContainerName').appendChild(nameelement);
            document.getElementById('ContainerNumber').appendChild(numberelement);
        }
        if(item.type == "CargoCreateJobOffer") {
            var Number = item.number
            var Name = item.name
            var Wahre = item.wahre
            var Zahlung = item.zahlung

            if (Number == 5) {
                document.getElementById('CargoJobsoffers').classList.add("CargoJobsoffersScroll");
            }

            var numberelement = document.createElement("button");
            var nameelement = document.createElement("div");
            var Wahreelement = document.createElement("div");
            var zahlungelement = document.createElement("div");
            nameelement.innerHTML = "Land: "+Name;
            Wahreelement.innerHTML = "Warre: "+Wahre;
            zahlungelement.innerHTML = "Zahlung: "+Zahlung;
            numberelement.classList.add(Number);
            nameelement.classList.add("CargoJobsoffersName");
            Wahreelement.classList.add("CargoJobsoffersWahre");
            zahlungelement.classList.add("CargoJobsoffersZahlung");
            document.getElementById('CargoJobsoffers').appendChild(numberelement);
            numberelement.appendChild(nameelement);
            numberelement.appendChild(Wahreelement);
            numberelement.appendChild(zahlungelement);
            numberelement.id = Number
            numberelement.onclick = function() { CargoJobOfferButtonClicked(Number); };
        }
        if(item.type == "CargoDelteJobOffer") {
            var Number = item.number

            var element = document.getElementById(Number)

            element.remove();
        }

    })



    //ESC = exit
    document.onkeyup = function (data) {
        if (data.which == 27) { // ESC
            $.post("https://Mockos_Jobs/exit", JSON.stringify({}));
            return
        }
    };


})