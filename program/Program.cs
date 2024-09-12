using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using TwitchLib.Client;
using TwitchLib.Client.Events;
using TwitchLib.Communication.Clients;
using TwitchLib.Communication.Models;

class Bot
{
    public TwitchClient client;
    public string text = "";
    public string chan = "";
    public List<string> msgs = new List<string>();
    public int con = 0;

    public Bot()
    {
        var clientOptions = new ClientOptions
        {
            MessagesAllowedInPeriod = 750,
            ThrottlingPeriod = TimeSpan.FromSeconds(30)
        };
        WebSocketClient customClient = new WebSocketClient(clientOptions);
        client = new TwitchClient(customClient);
    }

    public void Client_OnMessageReceived(object sender, OnMessageReceivedArgs e)//twitch
    {
        msgs.Add(e.ChatMessage.Username + "\x03" + e.ChatMessage.Message);
    }

    public void Client_OnJoinedChannel(object sender, OnJoinedChannelArgs e)//twitch
    {
        con = 1;
        chan = e.Channel;
    }
}

namespace BroTwitch
{
    static class Program
    {
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
