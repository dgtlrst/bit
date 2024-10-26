#[allow(dead_code)]
fn test_main(&self) {
    let start = std::time::Instant::now();
    let mut count = 0;
    loop {
        let received_data = self.receiver.try_recv();
        match received_data {
            std::result::Result::Ok(data) => {
                self.stream
                    .add(format!("Thread: {:?}, Echoing {:?}", self.thread_id, data));
            }
            Err(e) => match e {
                std::sync::mpsc::TryRecvError::Empty => {}
                std::sync::mpsc::TryRecvError::Disconnected => {
                    println!("Terminating Thread {:?}", self.thread_id);
                    break;
                }
            },
        }
        let instant = std::time::Instant::now();
        let time_since_start = instant.duration_since(start);
        let msgs_missed_since_start = time_since_start.as_secs() - count;
        if msgs_missed_since_start > 0 {
            println!(
                "Thread Controller {:?}: Time since start: {:?}, Msgs missed since start: {:?}",
                self.thread_id,
                time_since_start.as_secs().to_string(),
                (msgs_missed_since_start as i64 - 1).to_string()
            );
            for _i in 0..msgs_missed_since_start {
                match self.stream.add(format!(
                    "Thread: {:?}: {:?}",
                    self.thread_id, time_since_start
                )) {
                    std::result::Result::Ok(_) => {} // Succesfully Sent Message
                    Err(_) => {
                        println!(
                            "Thread Controller {:?}: Something went wrong.",
                            self.thread_id
                        );
                    }
                };
                count += 1;
            }
        }

        std::thread::sleep(Duration::from_millis(1))
    }
}
