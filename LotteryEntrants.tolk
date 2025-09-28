tolk 1.1

struct Entry {
    tickets: int;
    joined: uint32;
}

struct Storage {
    entrants: map<address, Entry>;
    totalTickets: int;
    description: string;
}

fun Storage.load() = Storage.fromCell(contract.getData());
fun Storage.save(self) = contract.setData(self.toCell());

fun enterLottery(tickets: int) {
    var st = Storage.load();
    let sender = get_caller();

    var e = st.entrants.get(sender);
    if (e.isFound) {
        var entry = e.loadValue();
        entry.tickets += tickets;
        st.entrants.set(sender, entry);
    } else {
        st.entrants.set(sender, Entry{tickets: tickets, joined: blockchain.now()});
    }

    st.totalTickets += tickets;
    st.description = "Lottery contract storing entrants in map, storage grows linearly.";
    st.save();
}
