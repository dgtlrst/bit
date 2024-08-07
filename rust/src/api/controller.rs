use std::collections::HashMap;
use std::{thread, time::Duration};

use crate::frb_generated::StreamSink;
use anyhow::{anyhow, bail, Ok, Result};
use flutter_rust_bridge::frb;
use serialport::Error;
use std::sync::mpsc::{self, Receiver, Sender};
use std::thread::JoinHandle;
struct ThreadController {
    thread_id: u32,
    stream: StreamSink<String>,
    receiver: Receiver<String>,
}
impl ThreadController {
    fn new(thread_id: u32, stream: StreamSink<String>, receiver: Receiver<String>) -> Self {
        ThreadController {
            thread_id,
            stream,
            receiver,
        }
    }

    fn test_msg(&self) {
        loop {
            let received_data = self.receiver.try_recv();
            match received_data {
                std::result::Result::Ok(data) => {
                    self.stream
                        .add(format!("Thread: {:?}, Echoing {:?}", self.thread_id, data));
                }
                Err(e) => {
                    // Could be disconnected, Could just be empty so we do nothing}
                }
            }
            self.stream
                .add(format!("Thread {:?}: Tick", self.thread_id));
            std::thread::sleep(Duration::from_millis(1000))
        }
    }
}

#[flutter_rust_bridge::frb(opaque)]
pub struct Controller {
    thread_id_counter: u32,
    thread_handles: Vec<JoinHandle<()>>,
    thread_transmitters: HashMap<u32, Sender<String>>,
}

impl Controller {
    #[flutter_rust_bridge::frb(sync)]
    pub fn new() -> Self {
        return Controller {
            thread_id_counter: 0,
            thread_handles: Vec::new(),
            thread_transmitters: HashMap::new(),
        };
    }
    fn get_new_thread_id(&mut self) -> u32 {
        let thread_id = self.thread_id_counter;
        self.thread_id_counter += 1;
        return thread_id;
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn push(&self, thread_id: u32, data: String) -> Result<()> {
        let tx = &self.thread_transmitters[&thread_id];
        match tx.send(data) {
            std::result::Result::Ok(_) => return Ok(()),
            Err(_) => return Err(anyhow!("Receiver disconnected!")),
        }
    }
    #[flutter_rust_bridge::frb(sync)]
    pub fn get_latest_thread_created(&self) -> u32 {
        // Due to the fact that creating a stream always returns a stream
        // We need to be able to get the streams thread id so we can push data
        // To the correct location.
        // Hence why we have this function.
        // PLEASE NOTE: This could cause a concurrency bug if you try to create lots of streams quickly
        // This should not happen since ideally we only create 4 or so but still.
        return self.thread_id_counter - 1;
    }

    #[flutter_rust_bridge::frb(sync)]
    pub fn create_stream(&mut self, stream_sink: StreamSink<String>) {
        let thread_closure =
            move |thread_id: u32, stream_sink: StreamSink<String>, rx: Receiver<String>| {
                let thread_controller = ThreadController::new(thread_id, stream_sink, rx);
                thread_controller.test_msg();
            };

        let thread_id = self.get_new_thread_id();
        let (tx, rx) = mpsc::channel();
        let handle = thread::spawn(move || thread_closure(thread_id, stream_sink, rx));
        self.thread_transmitters.insert(thread_id, tx);
        self.thread_handles.push(handle);
    }
}
