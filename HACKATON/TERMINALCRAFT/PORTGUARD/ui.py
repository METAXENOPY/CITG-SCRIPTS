from textual.app import App, ComposeResult
from textual.widgets import Header, Footer, DataTable, Static
from textual.reactive import reactive
from textual.containers import Container
import asyncio
from monitor import get_ports

class PortGuardApp(App):
    CSS_PATH = "style.css"
    BINDINGS = [("q", "quit", "Quit")]

    def compose(self) -> ComposeResult:
        yield Header()
        yield Footer()
        yield Container(Static("Loading...", id="status"), DataTable(id="table"))

    async def on_mount(self) -> None:
        self.status = self.query_one("#status", Static)
        self.table = self.query_one(DataTable)
        self.column_names = ["PID", "Local Address", "Remote Address", "Status"]
        self.column_widths = [8, 22, 22, 12]  # Fixed widths

        for name, width in zip(self.column_names, self.column_widths):
            self.table.add_column(name, width=width)

        self.table.cursor_type = "row"
        self.sort_column = "PID"
        self.sort_ascending = True
        self.table.add_class("sortable")
        await self.refresh_ports()
        self.set_interval(3, self.refresh_ports)

    async def refresh_ports(self):
        self.table.clear()

        ports = get_ports()
        all_rows = []
        for status, items in ports.items():
            for item in items:
                all_rows.append([
                    str(item["pid"]),
                    item["laddr"],
                    item["raddr"],
                    item["status"]
                ])

        # Sorting logic
        col_index = {"PID": 0, "Local Address": 1, "Remote Address": 2, "Status": 3}[self.sort_column]

        def sort_key(row):
            if col_index == 0:
                try:
                    return int(row[col_index])
                except ValueError:
                    return 0
            return row[col_index] or ""

        all_rows.sort(key=sort_key, reverse=not self.sort_ascending)

        for row in all_rows:
            self.table.add_row(*row)

        self.status.update(f"Active Connections: {len(all_rows)}")

    async def on_data_table_header_selected(self, event: DataTable.HeaderSelected) -> None:
        column_map = {
            0: "PID",
            1: "Local Address",
            2: "Remote Address",
            3: "Status"
        }

        column_index = event.column_index
        column_name = column_map.get(column_index)

        if column_name:
            if self.sort_column == column_name:
                self.sort_ascending = not self.sort_ascending
            else:
                self.sort_column = column_name
                self.sort_ascending = True
            await self.refresh_ports()
