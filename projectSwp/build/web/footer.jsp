<%-- 
    Document   : footer
    Created on : May 29, 2025, 9:37:59 AM
    Author     : BuiNgocLinh
--%>

<footer>
    
    <div class="footer-wrappper footer-bg">
        <!-- Footer Start-->
        <div class="footer-area footer-padding">
            <div class="container">
                <div class="row justify-content-between">
                    <div class="col-xl-4 col-lg-5 col-md-4 col-sm-6">
                        <div class="single-footer-caption mb-50">
                            <div class="single-footer-caption mb-30">
                                <!-- logo -->
                                <div class="footer-logo mb-25">
                                    <a href="index.html"><img src="assets/img/logo/logo2_footer.png" alt=""></a>
                                </div>
                                <div class="footer-tittle">
                                    <div class="footer-pera">
                                        <p>Learning starts the moment you decide to grow.</p>
                                    </div>
                                </div>
                                <!-- social -->
                                <div class="footer-social">
                                    <a href="#"><i class="fab fa-twitter"></i></a>
                                    <a href="https://bit.ly/sai4ull"><i class="fab fa-facebook-f"></i></a>
                                    <a href="#"><i class="fab fa-pinterest-p"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Education Services -->
                    <div class="col-xl-2 col-lg-3 col-md-4 col-sm-5">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-tittle">
                                <h4>Courses</h4>
                                <ul>
                                    <li><a href="#">Math</a></li>
                                    <li><a href="#">Science</a></li>
                                    <li><a href="#">Languages</a></li>
                                    <li><a href="#">History</a></li>
                                    <li><a href="#">More...</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Exams & Study -->
                    <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-tittle">
                                <h4>Study Materials</h4>
                                <ul>
                                    <li><a href="#">Quizzes</a></li>
                                    <li><a href="#">Past Papers</a></li>
                                    <li><a href="#">Tutorial Videos</a></li>
                                    <li><a href="#">Assignments</a></li>
                                    <li><a href="#">Packages</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Support -->
                    <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6">
                        <div class="single-footer-caption mb-50">
                            <div class="footer-tittle">
                                <h4>Support</h4>
                                <ul>
                                    <li><a href="#">FAQs</a></li>
                                    <li><a href="#">Help Center</a></li>
                                    <li><a href="#">Contact Us</a></li>
                                    <li><a href="#">Feedback</a></li>
                                    <li><a href="#">Terms & Policies</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- footer-bottom area -->
        <div class="footer-bottom-area">
            <div class="container">
                <div class="footer-border">
                    <div class="row d-flex align-items-center">
                        <div class="col-xl-12 ">
                            <div class="footer-copy-right text-center">
                                <p>
                                    &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | Made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Footer End-->
    </div>
</footer> 

<!-- Nút cu?n lên ??u trang -->
<!-- Giao di?n chatbot + nút Go to Top x?p d?c -->
<!-- Chatbot + Nút Go to Top -->
<div id="floating-tools">
  <div id="chatbot-box">
    <div id="chatbot-header">
      <img src="img/chatbot.png" onerror="this.style.display='none'" alt="Bot"> Chat h? tr?
    </div>
    <div id="chatbot-messages"></div>
    <textarea id="chatbot-input" placeholder="Nh?p câu h?i..."></textarea>
  </div>

  <div id="back-top">
    <a title="Go to Top" href="#"><i class="fas fa-level-up-alt"></i></a>
  </div>
</div>

<style>
  #floating-tools {
    position: fixed;
    bottom: 24px;
    right: 24px;
    display: flex;
    flex-direction: column;
    gap: 16px;
    z-index: 9999;
    align-items: flex-end;
  }

  #chatbot-box {
    width: 320px;
    height: 360px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 0 10px rgba(0,0,0,0.3);
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  #chatbot-header {
    display: flex;
    align-items: center;
    padding: 10px;
    background: #007bff;
    color: white;
    font-weight: bold;
  }

  #chatbot-header img {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    margin-right: 10px;
  }

  #chatbot-messages {
    padding: 10px;
    overflow-y: auto;
    flex: 1;
    background: #f9f9f9;
    font-size: 14px;
    max-height: 240px;
  }

  #chatbot-input {
    width: 100%;
    height: 60px;
    border: none;
    padding: 8px;
    box-sizing: border-box;
    border-top: 1px solid #ccc;
    resize: none;
  }

  .chat-msg {
    margin-bottom: 8px;
    line-height: 1.5;
  }

  .chat-user {
    font-weight: bold;
    color: #007bff;
  }

  .chat-bot {
    font-weight: bold;
    color: #28a745;
  }

  #back-top a {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 45px;
    height: 45px;
    background-color: #6c63ff;
    color: white;
    border-radius: 50%;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    text-decoration: none;
    font-size: 20px;
    position: fixed;
    bottom: 24px;
    right: 24px;
    z-index: 9998;
  }

  #back-top a:hover {
    background: #5a1bb0;
  }
</style>


<div id="floating-tools">
  <div id="chatbot-box">
    <div id="chatbot-header">
      <!-- Ki?m tra ?nh chatbot.png có th?t không, n?u không thì thay b?ng emoji -->
      <img src="img/chatbot.png" onerror="this.style.display='none'" alt="Bot"> Chat h? tr?
    </div>
    <div id="chatbot-messages"></div>
    <textarea id="chatbot-input" placeholder="Nh?p câu h?i..."></textarea>
  </div>

  <div id="back-top">
    <a title="Go to Top" href="#"><i class="fas fa-level-up-alt"></i></a>
  </div>
</div>

<script>
  const input = document.getElementById("chatbot-input");
  const messages = document.getElementById("chatbot-messages");

  input.addEventListener("keydown", function (e) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      const userText = input.value.trim();
      if (!userText) return;

      // Hi?n th? tin nh?n ng??i dùng
      const userMsg = document.createElement("div");
      userMsg.classList.add("chat-msg");
      userMsg.innerHTML = `<span class="chat-user">B?n:</span> ${userText}`;
      messages.appendChild(userMsg);

      input.value = "";

      // G?i ??n server
      fetch("chatbot-response?query=" + encodeURIComponent(userText))
        .then((res) => res.text())
        .then((data) => {
          const botMsg = document.createElement("div");
          botMsg.classList.add("chat-msg");
          botMsg.innerHTML = `<span class="chat-bot">Bot:</span> ${data}`;
          messages.appendChild(botMsg);
          messages.scrollTop = messages.scrollHeight;
        })
        .catch(() => {
          const errorMsg = document.createElement("div");
          errorMsg.classList.add("chat-msg");
          errorMsg.innerHTML = `<span class="chat-bot">Bot:</span> ? L?i k?t n?i ??n máy ch?.`;
          messages.appendChild(errorMsg);
        });
    }
  });
</script>






<!-- JS scripts remain unchanged -->
<script src="./assets/js/vendor/modernizr-3.5.0.min.js"></script>
<script src="./assets/js/vendor/jquery-1.12.4.min.js"></script>
<script src="./assets/js/popper.min.js"></script>
<script src="./assets/js/bootstrap.min.js"></script>
<script src="./assets/js/jquery.slicknav.min.js"></script>
<script src="./assets/js/owl.carousel.min.js"></script>
<script src="./assets/js/slick.min.js"></script>
<script src="./assets/js/wow.min.js"></script>
<script src="./assets/js/animated.headline.js"></script>
<script src="./assets/js/jquery.magnific-popup.js"></script>
<script src="./assets/js/gijgo.min.js"></script>
<script src="./assets/js/jquery.nice-select.min.js"></script>
<script src="./assets/js/jquery.sticky.js"></script>
<script src="./assets/js/jquery.barfiller.js"></script>
<script src="./assets/js/jquery.counterup.min.js"></script>
<script src="./assets/js/waypoints.min.js"></script>
<script src="./assets/js/jquery.countdown.min.js"></script>
<script src="./assets/js/hover-direction-snake.min.js"></script>
<script src="./assets/js/contact.js"></script>
<script src="./assets/js/jquery.form.js"></script>
<script src="./assets/js/jquery.validate.min.js"></script>
<script src="./assets/js/mail-script.js"></script>
<script src="./assets/js/jquery.ajaxchimp.min.js"></script>
<script src="./assets/js/plugins.js"></script>
<script src="./assets/js/main.js"></script>
