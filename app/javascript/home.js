$(document).ready(function () {
  const container = $("#dashboard-charts");

  const teams = container.data("teams");
  const usersByTeam = container.data("users-by-team");
  const usersByRole = container.data("users-by-role");
  const teamsStatus = container.data("teams-status");
  const usersOverTime = container.data("users-over-time");
  const teamCapacity = container.data("team-capacity");

  const colors = {
    blue: "rgba(54, 162, 235, 0.7)",
    green: "rgba(75, 192, 192, 0.7)",
    yellow: "rgba(255, 205, 86, 0.7)",
    red: "rgba(255, 99, 132, 0.7)",
    purple: "rgba(153, 102, 255, 0.7)",
    orange: "rgba(255, 159, 64, 0.7)",
  };

  const ctxTeam = $("#usersByTeamChart");
  new Chart(ctxTeam, {
    type: "bar",
    data: {
      labels: teams,
      datasets: [
        {
          label: "Number of Users",
          data: usersByTeam,
          backgroundColor: Object.values(colors),
        },
      ],
    },
    options: {
      responsive: true,
      scales: {
        y: { beginAtZero: true },
      },
    },
  });

  const ctxRole = $("#usersByRoleChart");
  new Chart(ctxRole, {
    type: "pie",
    data: {
      labels: ["Super Admin", "Admin", "Member"],
      datasets: [
        {
          data: usersByRole,
          backgroundColor: [colors.red, colors.yellow, colors.blue],
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          position: 'bottom'
        }
      }
    }
  });

  const ctxStatus = $("#teamsStatusChart");
  new Chart(ctxStatus, {
    type: "doughnut",
    data: {
      labels: ["Available Slots", "Full Teams"],
      datasets: [
        {
          data: teamsStatus,
          backgroundColor: [colors.green, colors.red],
        },
      ],
    },
  });

  const ctxOverTime = $("#usersOverTimeChart");
  new Chart(ctxOverTime, {
    type: "line",
    data: {
      labels: ["January", "February", "March", "April", "May", "June"],
      datasets: [
        {
          label: "Total Users",
          data: usersOverTime,
          backgroundColor: colors.blue,
          borderColor: colors.blue,
          fill: true,
          tension: 0.3,
        },
      ],
    },
  });

  const ctxCap = $("#teamCapacityChart");
  new Chart(ctxCap, {
    type: "bar",
    data: {
      labels: teamCapacity.map((t) => t.team),
      datasets: [
        {
          label: "Current Members",
          data: teamCapacity.map((t) => t.current),
          backgroundColor: colors.blue,
        },
        {
          label: "Maximum Capacity",
          data: teamCapacity.map((t) => t.max),
          backgroundColor: colors.green,
        },
      ],
    },
    options: { indexAxis: "y" },
  });
});
