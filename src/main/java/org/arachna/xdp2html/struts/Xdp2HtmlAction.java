/*
 * Copyright 2005, 2007 the original author or authors. Licensed under the
 * Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law
 * or agreed to in writing, software distributed under the License is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package org.arachna.xdp2html.struts;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.upload.FormFile;
import org.arachna.xdp2html.xslt.XdpHandler;
import org.w3c.tidy.Tidy;

/**
 * Convert a xdp formular into html
 */
public class Xdp2HtmlAction extends Action {

    /**
     * content type of returning stream
     */
    private static final String TEXT_HTML = "text/html";

    /**
     * constant submitURL (style sheet parameter)
     */
    public static final String SUBMIT_URL = "submitURL";

    /**
     * constant applicationURL (style sheet parameter)
     */
    public static final String APPLICATION_URL = "applicationURL";

    /**
     * Content disposition header name.
     */
    private static final String CONTENT_DISPOSITION = "Content-Disposition";

    /**
     * Content disposition header value.
     */
    private static final String DISPOSITION_INLINE = "inline; filename=";

    /**
     * Logger.
     */
    static Logger log = Logger.getLogger(Xdp2HtmlAction.class);

    /**
     * Method execute
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return ActionForward
     */
    @Override
    public ActionForward execute(final ActionMapping mapping, final ActionForm form, final HttpServletRequest request,
        final HttpServletResponse response) {
        final String url = getAbsoluteApplicationContextPath(request);
        final DynaActionForm fileForm = (DynaActionForm)form;
        final FormFile file = (FormFile)fileForm.get("file");

        try {
            final InputStream is = new ByteArrayInputStream(file.getFileData());
            final byte content[] = handleXdpFormular(url, is);

            if (content != null) {
                response.setContentLength(content.length);
                response.setContentType(TEXT_HTML);
                response.setHeader(CONTENT_DISPOSITION, DISPOSITION_INLINE + "formular");

                final OutputStream os = response.getOutputStream();
                os.write(content);
                os.flush();
                os.close();
            }
        }
        catch (final IOException ioe) {
            log.error(ioe.getMessage(), ioe);
        }

        return null;
    }

    /**
     * return the xdp formular as html
     * 
     * @param url
     *            URL to application (used to inject ressources during
     *            transformation)
     * @param xdp
     *            document as InputStream
     * @return ByteArray containing the transformed document
     */
    private byte[] handleXdpFormular(final String url, final InputStream is) {
        final XdpHandler handler = new XdpHandler();
        final Map<String, String> params = new HashMap<String, String>();

        // the resulting html page can then refer to ressources of the web
        // application
        params.put(APPLICATION_URL, url);

        // url the forms submit buttons points to
        params.put(SUBMIT_URL, "");

        // clean up html
        final Tidy tidy = new Tidy();
        tidy.setMakeClean(true);
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        tidy.parseDOM(new ByteArrayInputStream(handler.handle(is, params)), baos);

        return baos.toByteArray();
    }

    /**
     * build url to application from request
     * 
     * @param request
     *            HttpServletRequest
     * @return string containing url to application
     */
    private String getAbsoluteApplicationContextPath(final HttpServletRequest request) {
        final StringBuilder sb = new StringBuilder();
        final String protocol = request.getProtocol();

        sb.append(protocol.substring(0, protocol.indexOf('/'))).append("://").append(request.getServerName())
            .append(":").append(request.getServerPort()).append(request.getContextPath());

        return sb.toString();
    }
}
