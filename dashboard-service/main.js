// === API URLS ===
const API_BASE_URL = "http://localhost:8080";

const CARS_URL = `${API_BASE_URL}/telemetry/cars`;
const TELEMETRY_URL = (carCode) =>
  `${API_BASE_URL}/telemetry/cars/${carCode}/readings/latest`;
const ALERTS_ACTIVE_URL = (carCode) =>
  `${API_BASE_URL}/alerts/alerts?car_code=${carCode}&status=active`;
const ALERTS_CLOSED_URL = (carCode, since) =>
  `${API_BASE_URL}/alerts/alerts?car_code=${carCode}&status=closed&since=${since}&limit=20`;

const F1_LOGO_URL =
  "https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/F1.svg/320px-F1.svg.png";

let selectedCarCode = 1;
let carsData = [];
const previousValues = {};

async function loadCars() {
  const response = await fetch(CARS_URL);
  const cars = await response.json();
  carsData = cars;
  const carSelect = document.getElementById("carSelect");
  carSelect.innerHTML = "";

  cars.forEach((car) => {
    const option = document.createElement("option");
    option.value = car.car_code;
    option.text = `${car.driver} (${car.chassis})`;
    carSelect.appendChild(option);
  });

  selectedCarCode = cars[0].car_code;
  carSelect.value = selectedCarCode;
  updateDriverInfo(selectedCarCode);

  carSelect.addEventListener("change", (e) => {
    selectedCarCode = parseInt(e.target.value);
    updateDriverInfo(selectedCarCode);
    updateDashboard();
  });
}

function updateDriverInfo(carCode) {
  const car = carsData.find((c) => c.car_code === parseInt(carCode));
  if (car) {
    document.getElementById("driverImg").src = car.driver_photo_url;
    document.getElementById(
      "driverName"
    ).textContent = `#${car.car_code} ${car.driver}`;
  } else {
    document.getElementById("driverImg").src = "";
    document.getElementById("driverName").textContent = "";
  }
}

function severityColor(severity) {
  switch (severity) {
    case "critical":
      return "bg-red-100 border-red-500";
    case "warning":
      return "bg-yellow-100 border-yellow-500";
    case "info":
      return "bg-blue-100 border-blue-500";
    default:
      return "bg-gray-100 border-gray-400";
  }
}

async function fetchAlerts() {
  try {
    const response = await fetch(ALERTS_ACTIVE_URL(selectedCarCode));
    const alerts = await response.json();
    const container = document.getElementById("alerts");
    container.innerHTML = "";

    if (alerts.length === 0) {
      container.innerHTML = "<p class='text-gray-500'>No active alerts</p>";
    } else {
      alerts.forEach((alert) => {
        const div = document.createElement("div");
        div.className = `p-2 border-l-4 ${severityColor(
          alert.severity
        )} rounded shadow-sm`;
        div.innerHTML = `
          <strong>${alert.metric}</strong>: ${alert.last_value} (${
          alert.operator
        } ${alert.threshold})<br>
          <span class="text-xs">Severity: ${alert.severity}, Since: ${new Date(
          alert.opened_at
        ).toLocaleTimeString()}</span>
        `;
        container.appendChild(div);
      });
    }
  } catch (error) {
    console.error("Error fetching alerts:", error);
  }
}

async function fetchHistory() {
  try {
    const sinceDate = new Date();
    sinceDate.setHours(sinceDate.getHours() - 24);
    const sinceISO = sinceDate.toISOString();

    const response = await fetch(ALERTS_CLOSED_URL(selectedCarCode, sinceISO));
    const alerts = await response.json();
    const container = document.getElementById("history");
    container.innerHTML = "";

    if (alerts.length === 0) {
      container.innerHTML = "<p class='text-gray-500'>No alert history</p>";
    } else {
      alerts.forEach((alert) => {
        const div = document.createElement("div");
        div.className = `p-2 bg-gray-100 border border-gray-300 rounded text-sm text-gray-700`;
        div.innerHTML = `
          <strong>${alert.metric}</strong>: ${alert.last_value} (${
          alert.operator
        } ${alert.threshold})<br>
          <span class="text-xs text-gray-500">Severity: ${
            alert.severity
          }, Opened: ${new Date(
          alert.opened_at
        ).toLocaleTimeString()}, Closed: ${
          alert.closed_at
            ? new Date(alert.closed_at).toLocaleTimeString()
            : "active"
        }</span>
        `;
        container.appendChild(div);
      });
    }
  } catch (error) {
    console.error("Error fetching history:", error);
  }
}

async function fetchTelemetry() {
  try {
    const response = await fetch(TELEMETRY_URL(selectedCarCode));
    const data = await response.json();
    const telemetryBody = document.getElementById("telemetry");
    telemetryBody.innerHTML = "";

    data.readings.forEach((reading) => {
      const metric = reading.metric;
      const value = reading.value;
      const prevValue = previousValues[metric];

      const tr = document.createElement("tr");
      tr.className =
        prevValue !== undefined && prevValue !== value ? "bg-yellow-100" : "";
      tr.innerHTML = `
        <td class="px-2 py-1">${metric}</td>
        <td class="px-2 py-1">${value}</td>
        <td class="px-2 py-1">${new Date(
          reading.updated_at
        ).toLocaleTimeString()}</td>
      `;
      telemetryBody.appendChild(tr);
      previousValues[metric] = value;
    });
  } catch (error) {
    console.error("Error fetching telemetry:", error);
  }
}

function updateDashboard() {
  fetchAlerts();
  fetchHistory();
  fetchTelemetry();
}

loadCars().then(() => {
  updateDashboard();
  setInterval(updateDashboard, 1000);
});
